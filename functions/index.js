'use strict';
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const dates = require('./date');

const utils = require('./utils');

const REQUEST_COLLECTION = 'requests';
const GROUPS_COLLECTION = 'groups';
const MATCH_COLLECTION = 'matches';
const DISCOVER_COLLECTION = 'discover';
const RECOMMENDATION_COLLECTION = 'recommendations';
const NOTIFICATION_COLLECTION = 'notifications';
const USER_COLLECTION = 'users';
const QUERY_COLLECTION = 'queries';
const ALGOLIA_API_KEY_COLLECTION = 'algolia_api_keys';

admin.initializeApp();

const firestore = admin.firestore();
const fcm = admin.messaging();

// addRequest - Creates a user request for another user's services. Checks the existence
// of an existing request or match between the two users before adding the Request document
// into Firestore.
// - Function is called from the mobile client using the Firebase Cloud Functions SDK.
// - User must be authenticated to call this function.
// Payload:
// {
//      "receiver_id": <STRING>, - REQUIRED - User id of target user
//      "comment": <STRING>, - OPTIONAL - Comment to add with the request
//      "type": <STRING>, - REQUIRED - The type of the request, "offering" or "ask"
//      "index": <INT>, - REQUIRED - The index of the skill on the user profile
//      "time": <DATETIME>, - OPTIONAL - The time for the service to occur
// }
exports.addRequest = functions.https.onCall(async (data, context) => {

    // Checking that the user is authenticated.
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const receiverId = data.receiver_id;
    const referralId = data.referral_id;
    const comment = data.comment ? data.comment : "";
    const referralComment = data.referral_comment ? data.referral_comment : "";
    const skillType = data.type;
    const skillIndex = data.index;
    const requestTime = data.time ? new Date(data.time) : data.time;

    var output = {};
    var terminate = false;

    // Checking attribute.
    if (!(typeof receiverId === 'string') || receiverId.length === 0) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'valid receiver_id.');
    }

    if (!skillType || !(typeof skillType === 'string') || !(skillType === 'offer' || skillType === 'request')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'valid type.');
    }

    if ((comment && !(typeof comment === 'string')) || (referralComment && !(typeof referralComment === 'string'))) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'valid comment.');
    }

    if (!(typeof skillIndex === 'number') || !((skillIndex >= 0 && skillIndex <= 2) || skillIndex === 100 || skillIndex === 200)) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'valid index.');
    }

    const uid = context.auth.uid;

    if (receiverId === uid) {
        throw new functions.https.HttpsError('invalid-argument', 'The target user id cannot be the same as the sender id.');
    }

    if (referralId && (referralId === uid || referralId === receiverId)) {
        throw new functions.https.HttpsError('invalid-argument', 'The referral user id cannot be the same as the sender id or the target user id.');
    }

    const user = await firestore.collection('users').doc(receiverId).get().then((doc) => {
        if (!doc.exists) {
            throw new functions.https.HttpsError('not-found', 'The target user id does not exist.');
        }
        return doc.data();
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (referralId) {
        await firestore.collection('users').doc(referralId).get().then((doc) => {
            if (!doc.exists) {
                throw new functions.https.HttpsError('not-found', 'The user referral id does not exist.');
            }
            return doc.data();
        }).catch((error) => {
            throw new functions.https.HttpsError('unknown', error.message, error);
        });
    }


    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', uid).where('receiver_id', '==', receiverId).where('status', '==', 0).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) {
            terminate = true;
            output = { 'status': 'failure', 'message': 'Request has already been sent.' };
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', uid).where('receiver_id', '==', receiverId).where('status', '==', 10).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) {
            terminate = true;
            output = { 'status': 'failure', 'message': 'Request has already been sent.' };
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (terminate) {
        return output;
    }

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', receiverId).where('receiver_id', '==', uid).where('status', '==', 0).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) {
            terminate = true;
            output = { 'status': 'failure', 'message': 'Request has already been received. Check your requests.' };
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', receiverId).where('receiver_id', '==', uid).where('status', '==', 10).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) {
            terminate = true;
            output = { 'status': 'failure', 'message': `${user.display_name} is currently being referred to you. Please wait for the referral.` };
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (terminate) {
        return output;
    }

    const matchId = (utils.hashCode(uid) < utils.hashCode(receiverId)) ? uid + receiverId : receiverId + uid;

    await firestore.collection(MATCH_COLLECTION).doc(matchId).get().then((doc) => {
        if (doc.exists) {
            terminate = true;
            output = { 'status': 'failure', 'message': 'You are already connected!' };
            return;
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (terminate) {
        return output;
    }

    var skill;
    if (skillIndex === 100) {
        skill = {
            "name": "Personal",
            "price": 0,
            "duration": 30,
        };
    } else if (skillIndex === 200) {
        skill = {
            "name": "Business",
            "price": 0,
            "duration": 30,
        };
    } else {
        skill = skillType === "offer" ? user.teach_skill[skillIndex] : user.learn_skill[skillIndex];
    }

    const payer = skillType === "offer" ? uid : receiverId;

    // Create document
    const doc = {
        "sender_id": uid,
        "receiver_id": receiverId,
        "referral_id": referralId ? referralId : "",
        "payer": payer,
        "skill": skill["name"],
        "price": skill["price"],
        "duration": skill["duration"],
        "status": referralId ? 10 : 0,
        "type": skillType,
        "comment": comment,
        "referral_comment": referralComment,
        "time": requestTime,
        "created_on": admin.firestore.Timestamp.now(),
    };

    return firestore.collection(REQUEST_COLLECTION).add(doc).then(() => {
        return { "status": "success", "data": doc, "message": "Successfully sent request." };
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

});

// onRequestReceived - Sends a push notification using Firebase Cloud Messaging with tokens 
// to the user when a request is received.
// - Function is triggered when a new request document is created in the "requests" collection in Firestore.
exports.onRequestReceived = functions.firestore.document('requests/{requestId}').onCreate(async (snap, context) => {

    const data = snap.data();

    const senderId = data.sender_id;
    const receiverId = data.receiver_id;
    const requestId = context.params.requestId;

    const querySnapshot = await firestore
        .collection(USER_COLLECTION)
        .doc(receiverId)
        .collection('tokens')
        .where('active', '==', true)
        .get();

    const tokens = querySnapshot.docs.map(snap => snap.data().token);

    if (!Array.isArray(tokens) || !tokens.length) {
        console.log("Token doesn't exist")
        return;
    }

    const sender = await firestore
        .collection(USER_COLLECTION)
        .doc(senderId).get().then((docSnapshot) => {
            return docSnapshot.data();
        }).catch((error) => {
            console.log(error);
        });

    const payload = {
        notification: {
            title: `${sender.display_name} sent you a request!`,
            body: "Accept to continue the conversation.",
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
            screen: "request",
            request_id: requestId
        }
    };

    return fcm.sendToDevice(tokens, payload);
});

// createMatch - Creates a match after a user has accepted a request. Once the match is
// created, 2 messages are sent in the conversation. The first message contains the 
// request details, and the second message notifies each user that the other has
// accepted the request.
// - Function is triggered when a request has been accepted (status is 1) in the "requests" collection.
exports.createMatch = functions.firestore.document('requests/{requestId}').onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    const oldStatus = previousValue.status;
    const newStatus = newValue.status;

    if (oldStatus === newStatus || newStatus !== 1) {
        return { 'status': 'SKIPPED', 'message': 'Status condition not met.' };
    }

    const receiverId = newValue.receiver_id;
    const senderId = newValue.sender_id;

    const time = admin.firestore.Timestamp.now();
    var firstMessageTime = time.toDate();
    firstMessageTime.setSeconds(firstMessageTime.getSeconds() + 1);

    const matchId = (utils.hashCode(senderId) < utils.hashCode(receiverId)) ? senderId + receiverId : receiverId + senderId;

    var read = {};
    read[senderId] = false;
    read[receiverId] = false;

    const match = {
        "user_id": [senderId, receiverId],
        "sender_id": senderId,
        "payer": newValue.payer,
        "status": 0,
        "time": newValue.time,
        "read": read,
        "created_on": time,
        "last_updated": time,
    };

    const matchRef = firestore.collection(MATCH_COLLECTION).doc(matchId);

    const create = matchRef.get().then(matchDoc => {
        return !matchDoc.exists;
    });

    if (!create) {
        return { "status": "failure", "message": "Match already exists." };
    }

    const sender = await firestore.collection(USER_COLLECTION).doc(senderId).get().then((documentSnapshot) => {
        return documentSnapshot.data();
    }).catch((error) => {
        console.log(error);
    });

    if (sender === null) {
        return { "status": "failure" }
    }

    const receiver = await firestore.collection(USER_COLLECTION).doc(receiverId).get().then((documentSnapshot) => {
        return documentSnapshot.data();
    }).catch((error) => {
        console.log(error);
    });

    if (receiver === null) {
        return { "status": "failure" }
    }

    const systemMessage = {
        "timestamp": time,
        "data": { "time": newValue.time, "price": newValue.price, "skill": newValue.skill, "title": "Request Details" },
        "type": 0,
        "event": "match_start",
        "source": 1
    };

    const receiverMessage = `You accepted ${sender.display_name}'s request and invited them to start the chat`;
    const senderMessage = `${receiver.display_name} accepted your request and invited you to start the chat`;

    const firstMessage = {
        "sender_id": receiverId,
        "timestamp": firstMessageTime,
        "data": { receiver: receiverMessage, sender: senderMessage },
        "type": 0,
        "source": 0
    };

    await matchRef.set(match, { merge: true }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await matchRef.collection('messages').doc(`${matchId}-match-start`).set(systemMessage, { merge: true }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await matchRef.collection('messages').doc(`${matchId}-first-message`).set(firstMessage, { merge: true }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await matchRef.set({ "last_updated": firstMessageTime }, { merge: true }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    return { "status": "success", "data": match }
});

// Set up Algolia.
const algoliaClient = algoliasearch(functions.config().algolia.appid, functions.config().algolia.apikey);
const collectionIndex = algoliaClient.initIndex('users');

// generateAlgoliaSearchApiKeys - Generates secured Algolia API keys for users and adds
// them to the "algolia_api_keys" firestore collection. This function should only be run
// when there are no valid API keys in the "algolia_api_keys" collection, usually when an
// environment is first created or if all of the API keys have expired.
// - Function is called mannually by the developer when necessary.
exports.generateAlgoliaSearchApiKeys = functions.https.onRequest(async (req, res) => {

    const searchOnlyApiKey = functions.config().algolia.searchonlyapikey;
    const numKeys = 20;

    const time = admin.firestore.Timestamp.now();
    const duration = 31104000; // in seconds (1 year)

    var batch = firestore.batch();

    var i;
    for (i = 0; i < numKeys; i++) {
        const validUntil = time.seconds + duration + (i * 600);
        const validUntilDate = new Date(validUntil * 1000);

        const key = algoliaClient.generateSecuredApiKey(searchOnlyApiKey, {
            validUntil: validUntil
        });

        const document = {
            "key": key,
            "valid_until": validUntilDate,
            "created_on": time,
            "public": i < 10
        };

        batch.set(firestore.collection(ALGOLIA_API_KEY_COLLECTION).doc(), document);
    }

    return batch.commit().then(() => {
        res.status(200).send("Successfully updated API keys.");
        return;
    }).catch((error) => {
        console.log(error);
        res.status(500).send(error);
        return;
    });
});

// getQueryApiKey - Returns an authenticated Algolia API key. Each user can only have one
// API key at a time. The first time this function is called by a user, the API key is
// stored in the "queries" collection in Firestore. Every subsequent call will retrieve
// that API key.
// - Function is called from the mobile client using the Firebase Cloud Functions SDK.
// - User must be authenticated to call this function.
exports.getQueryApiKey = functions.https.onCall(async (data, context) => {

    const timestamp = admin.firestore.Timestamp.now();
    const time = timestamp.toDate();

    // Return public API key if not authenticated
    if (!context.auth) {
        return firestore.collection(ALGOLIA_API_KEY_COLLECTION).where('public', '==', true).where('valid_until', '>=', time).get().then((querySnapshot) => {
            return {
                "application_id": functions.config().algolia.appid,
                "api_key": querySnapshot.docs[Math.floor(Math.random() * querySnapshot.docs.length)].data().key
            };
        });
    }

    const uid = context.auth.uid;

    const queryDoc = firestore.collection(QUERY_COLLECTION).doc(uid);
    const docSnapshot = await queryDoc.get();

    if (docSnapshot.exists) {
        const apiKey = docSnapshot.data().key;
        const validKey = await firestore.collection(ALGOLIA_API_KEY_COLLECTION).where("key", "==", apiKey).get().then((querySnapshot) => {
            if (querySnapshot.empty) {
                return false;
            }

            const keyData = querySnapshot.docs[0].data();

            return keyData.valid_until.toDate() > time;
        }).catch((error) => {
            console.log(error);
            return false;
        });

        if (validKey) {
            return {
                "application_id": functions.config().algolia.appid,
                "api_key": apiKey
            };
        }
    }

    const apiKey = await firestore.collection(ALGOLIA_API_KEY_COLLECTION).where('public', '==', false).where('valid_until', '>=', time).get().then((querySnapshot) => {
        if (querySnapshot.empty) {
            const searchOnlyApiKey = functions.config().algolia.searchonlyapikey;
            const duration = 31104000; // in seconds (1 year)

            const validUntil = timestamp.seconds + duration;
            const validUntilDate = new Date(validUntil * 1000);

            const key = algoliaClient.generateSecuredApiKey(searchOnlyApiKey, {
                validUntil: validUntil
            });

            const document = {
                "key": key,
                "valid_until": validUntilDate,
                "created_on": timestamp
            };

            firestore.collection(ALGOLIA_API_KEY_COLLECTION).add(document).catch((error) => {
                console.log(error);
                return;
            });

            return key;
        }

        return querySnapshot.docs[Math.floor(Math.random() * querySnapshot.docs.length)].data().key;

    }).catch((error) => {
        console.log(error);
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    const queryDocument = {
        "key": apiKey,
        "last_updated": timestamp
    };

    firestore.collection(QUERY_COLLECTION).doc(uid).set(queryDocument, { merge: true }).catch((error) => {
        console.log(error);
    });

    return {
        "application_id": functions.config().algolia.appid,
        "api_key": apiKey
    };
});

// sendCollectionToAlgolia - Sends all of the current users to Algolia for indexing.
// This function should be called to manually update Algolia when needed.
// - Function is called mannually by the developer when necessary.
exports.sendCollectionToAlgolia = functions.https.onRequest(async (req, res) => {

    // This array will contain all records to be indexed in Algolia.
    // A record does not need to necessarily contain all properties of the Firestore document,
    // only the relevant ones. 
    const algoliaRecords = [];

    // Retrieve all documents from the COLLECTION collection.
    const querySnapshot = await firestore.collection('users').get();

    querySnapshot.docs.forEach(doc => {
        const document = doc.data();
        // Essentially, you want your records to contain any information that facilitates search, 
        // display, filtering, or relevance. Otherwise, you can leave it out.
        const record = {
            objectID: doc.id,
            user_id: doc.id,
            display_name: document.display_name,
            photo_url: document.photo_url,
            about: document.about,
        };

        if (document.teach_skill) {
            record.teach_skill = Object.values(document.teach_skill);
        }

        if (document.learn_skill) {
            record.learn_skill = Object.values(document.learn_skill);
        }

        if (document.title) {
            record.title = document.title;
        }

        if (document.interests) {
            record.interests = document.interests;
        }

        if (document.availability) {
            record.availability = document.availability;
        }

        if (document.time_zone) {
            record.time_zone = document.time_zone;
        }

        algoliaRecords.push(record);
    });

    // After all records are created, we save them to 
    return collectionIndex.saveObjects(algoliaRecords).then(() => {
        res.status(200).send("COLLECTION was indexed to Algolia successfully.");
        return;
    }).catch((error) => {
        console.log(error);
        res.status(500).send(error);
        return;
    });

})

// setAlgoliaSearchAttributes - Sets the searchable attributes on Algolia. This function should 
// only be called when an environment is first created or when the searchable attributes need to
// be updated.
// - Function is called mannually by the developer when necessary.
exports.setAlgoliaSearchAttributes = functions.https.onRequest(async (req, res) => {

    return collectionIndex.setSettings({
        typoTolerance: false,
        searchableAttributes: [
            'teach_skill.name',
            'learn_skill.name',
            'teach_skill.description',
            'learn_skill.description',
            'title',
            'about',
            'interests',
            'display_name',
        ],
        attributesForFaceting: [
            'filterOnly(user_id)',
        ],
    }).then(() => {
        res.status(200).send("Algolia search attributes set successfully.");
        return;
    });
});

// onUserCreated - Indexes a user on Algolia when a User is initially created in the "users"
// Firestore collection.
// - Function is triggered when a new user document is created in the "users" collection in Firestore.
exports.onUserCreated = functions.firestore.document('users/{userId}').onCreate((snapshot, context) => {

    const userId = context.params.userId;

    if (snapshot.exists) {
        const user = snapshot.data();

        if (user) {
            if (Object.entries(user.teach_skill).length !== 0 || Object.entries(user.learn_skill).length !== 0) {
                const record = {
                    objectID: userId,
                    user_id: userId,
                    display_name: user.display_name,
                    photo_url: user.photo_url,
                    about: user.about,
                };

                if (user.teach_skill) {
                    record.teach_skill = Object.values(user.teach_skill);
                }

                if (user.learn_skill) {
                    record.learn_skill = Object.values(user.learn_skill);
                }

                if (user.title) {
                    record.title = user.title;
                }

                if (user.interests) {
                    record.interests = user.interests;
                }

                if (user.availability) {
                    record.availability = user.availability;
                }

                if (user.time_zone) {
                    record.time_zone = user.time_zone;
                }


                // Write to the algolia index
                return collectionIndex.saveObject(record);
            }
        }
    }
    return { 'message': 'Not updated.' };
});

// onChatUpdated - Sends a push notification to the specified user when a message is sent
// in a match/chat using Firebase Cloud Messaging with tokens.
// - Function is triggered when a new message document is created in the "messages" subcollection of any "match" docuent in Firestore.
exports.onChatUpdated = functions.firestore.document('matches/{matchId}/messages/{messageId}').onCreate(async (snap, context) => {

    const data = snap.data();

    const event = data.event;

    if (event !== null && event === "match_start") {
        return { "status": "skipped", "message": "Match start message skipped." };
    }

    const matchId = context.params.matchId;
    const senderId = data.sender_id;

    const receiverId = matchId.replace(senderId, '');

    // Set chat to unread
    firestore.collection(MATCH_COLLECTION).doc(matchId).get().then((documentSnapshot) => {
        const data = documentSnapshot.data();

        if (data.read !== undefined) {
            if (data.read[receiverId]) {
                const fieldName = `read.${receiverId}`;
                var update = {};
                update[fieldName] = false;

                return firestore.collection(MATCH_COLLECTION).doc(matchId).update(update).catch((error) => {
                    console.log(error)
                });
            }
        }
        return null;
    }).catch((error) => {
        console.log(error)
    });

    // Get FCM device token to send push notifications
    const querySnapshot = await firestore
        .collection(USER_COLLECTION)
        .doc(receiverId)
        .collection('tokens')
        .where('active', '==', true)
        .get();

    const tokens = querySnapshot.docs.map(snap => snap.data().token);

    if (!Array.isArray(tokens) || !tokens.length) {
        console.log("Token doesn't exist")
        return;
    }

    const sender = await firestore
        .collection(USER_COLLECTION)
        .doc(senderId).get();
    const senderData = sender.data();

    var message = "";
    if (data.text !== undefined) {
        message = data.text;
    } else if (data.text === undefined && data.data !== undefined) {
        const messageData = data.data;
        const senderMessage = messageData["sender"];
        const receiverMessage = messageData["receiver"];

        if (senderMessage !== null && receiverMessage !== null) {
            message = senderMessage;
        }
    }

    const payload = {
        notification: {
            title: senderData.display_name,
            body: message,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
            screen: "message",
            match_id: matchId
        }
    };

    return fcm.sendToDevice(tokens, payload);
});

// onNotificationUpdated - Sends a push notifiation to the specific user when a notification is
// added or updated in the "notifications" collection.
// - Function is triggered when a new notification document is created or updated in the "notifications" collection in Firestore.
exports.onNotificationUpdated = functions.firestore.document('notifications/{userId}/notifications/{notificationId}').onWrite(async (change, context) => {

    const docBeforeChange = change.before.data();
    const docAfterChange = change.after.data();

    if (!docAfterChange) {
        console.log("Notification document does not exist.");
        return;
    }

    const count = docAfterChange.count;

    if (docBeforeChange && docAfterChange) {
        const oldCount = docBeforeChange.count;

        if (count <= oldCount) {
            console.log(`New notification count (${count}) less than or equal to old notification count (${oldCount})`);
            return;
        }
    }

    const userId = context.params.userId;
    const senderId = docAfterChange.from;
    const data = docAfterChange.data;

    const querySnapshot = await firestore
        .collection(USER_COLLECTION)
        .doc(userId)
        .collection('tokens')
        .where('active', '==', true)
        .get();

    const tokens = querySnapshot.docs.map(snap => snap.data().token);

    if (!Array.isArray(tokens) || !tokens.length) {
        console.log("FCM token doesn't exist")
        return;
    }

    const sender = await firestore
        .collection(USER_COLLECTION)
        .doc(senderId).get();
    const senderData = sender.data();

    const notificationType = docAfterChange.object;

    var message = "";
    if (notificationType === 'like' && count === 1) {
        message = `${senderData.display_name} liked your post.`;
    } else if (notificationType === 'like' && count === 2) {
        message = `${senderData.display_name} and 1 other liked your post.`;
    } else if (notificationType === 'like' && count > 2) {
        message = `${senderData.display_name} and ${count - 1} others liked your post.`;
    } else if (notificationType === 'comment' && count === 1) {
        message = `${senderData.display_name} commented on your post: ${data}`;
    } else if (notificationType === 'comment' && count === 2) {
        message = `${senderData.display_name} and 1 other commented on your post: ${data}`;
    } else if (notificationType === 'comment' && count > 2) {
        message = `${senderData.display_name} and ${count - 1} others commented on your post: ${data}`;
    }

    const unreadNotifications = await firestore
        .collection(NOTIFICATION_COLLECTION)
        .doc(userId)
        .collection('notifications')
        .where('read', '==', false)
        .get().then((querySnapshot) => {
            return querySnapshot.size;
        });

    const payload = {
        notification: {
            body: message,
            click_action: 'FLUTTER_NOTIFICATION_CLICK', // required only for onResume or onLaunch callbacks
            badge: unreadNotifications.toString(),
        },
        data: {
            screen: "post",
            notification_id: change.after.id,
            parent: docAfterChange.parent,
            parent_id: docAfterChange.parent_id,
            target: docAfterChange.target,
            target_id: docAfterChange.target_id,
            object: docAfterChange.object,
            object_id: docAfterChange.object_id
        }
    };
    console.log(payload);
    return fcm.sendToDevice(tokens, payload);
});

// onPostCommented - Adds a notification document to the "notifications" collection for a specific user in Firestore
// when a post is commented.
// - Function is triggered when a new comment document is created in the "comments" subcollection of a post document in Firestore.
exports.onPostCommented = functions.firestore.document('groups/{groupId}/posts/{postId}/comments/{commentId}').onCreate(async (snap, context) => {

    const data = snap.data();
    const groupId = context.params.groupId;
    const postId = context.params.postId;
    const commentId = context.params.commentId;

    const fromUserId = data.from;
    const message = data.message && typeof data.message === 'string' ? data.message.slice(0, 100) : '';
    const createdOn = data.created_on;

    const notification = {
        "from": fromUserId,
        "object_id": commentId,
        "data": message,
        "read": false,
        "last_updated": createdOn,
    };

    const post = await firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).get().then((documentSnapshot) => {
        return documentSnapshot.data();
    }).catch((error) => {
        console.log(error);
    });

    const postUserId = post.from;

    if (postUserId === fromUserId) {
        return;
    }

    const userNotificationRef = firestore.collection(NOTIFICATION_COLLECTION).doc(postUserId);

    userNotificationRef.set({
        "read": false,
        "last_updated": createdOn
    }, { merge: true });

    const notificationId = `${postId}-comment`;

    const notificationRef = userNotificationRef.collection('notifications').doc(notificationId);

    notificationRef.collection('child_notifications').doc(commentId).set({
        "data": message,
        "from": fromUserId,
        "created_on": createdOn,
    }, { merge: true });

    return notificationRef.get().then((docSnapshot) => {
        if (!docSnapshot.exists) {
            notification["verb"] = "add";
            notification["object"] = "comment";
            notification["target"] = "post";
            notification["target_id"] = postId;
            notification["parent"] = "group";
            notification["parent_id"] = groupId;
            notification["count"] = 1;
            notification["created_on"] = createdOn;

            return notificationRef.set(notification);
        } else {
            const data = docSnapshot.data();
            notification["count"] = data.count + 1;

            return notificationRef.set(notification, { merge: true });
        }
    }).catch((error) => {
        console.log(error);
    });
});

// onPostLiked - Adds a notification document to the "notifications" collection for a specific user in Firestore
// when a post is liked.
// - Function is triggered when a new like document is created in the "likes" subcollection of a post document in Firestore.
exports.onPostLiked = functions.firestore.document('groups/{groupId}/posts/{postId}/likes/{likeId}').onCreate(async (snap, context) => {

    const data = snap.data();
    const groupId = context.params.groupId;
    const postId = context.params.postId;
    const likeId = context.params.likeId;

    const fromUserId = data.from;
    const createdOn = data.created_on;

    const notification = {
        "from": fromUserId,
        "object_id": likeId,
        "read": false,
        "last_updated": createdOn,
    };

    const post = await firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).get().then((documentSnapshot) => {
        return documentSnapshot.data();
    }).catch((error) => {
        console.log(error);
    });

    const postUserId = post.from;

    if (postUserId === fromUserId) {
        return;
    }

    const userNotificationRef = firestore.collection(NOTIFICATION_COLLECTION).doc(postUserId);

    userNotificationRef.set({
        "read": false,
        "last_updated": createdOn
    }, { merge: true });

    const notificationId = `${postId}-like`;

    const notificationRef = userNotificationRef.collection('notifications').doc(notificationId);

    notificationRef.collection('child_notifications').doc(likeId).set({
        "from": fromUserId,
        "created_on": createdOn,
    }, { merge: true });

    return notificationRef.get().then((docSnapshot) => {
        if (!docSnapshot.exists) {
            notification["verb"] = "like";
            notification["object"] = "like";
            notification["target"] = "post";
            notification["target_id"] = postId;
            notification["parent"] = "group";
            notification["parent_id"] = groupId;
            notification["count"] = 1;
            notification["created_on"] = createdOn;

            return notificationRef.set(notification);
        } else {
            const data = docSnapshot.data();
            notification["count"] = data.count + 1;

            return notificationRef.set(notification, { merge: true });
        }
    }).catch((error) => {
        console.log(error);
    });
});

// countPostComments - Increments the "comment_count" field in a post document, which acts
// as a counter for the number of comments on the post.
// TODO: make this idempotent
// - Function is triggered when a new comment document is created in the "comments" subcollection of a post document in Firestore.
exports.countPostComments = functions.firestore.document('groups/{groupId}/posts/{postId}/comments/{commentId}').onWrite(async (change, context) => {

    const groupId = context.params.groupId;
    const postId = context.params.postId;

    if (!change.before.exists) {
        return firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).update({ "comment_count": admin.firestore.FieldValue.increment(1) });
    } else if (!change.after.exists) {
        return firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).update({ "comment_count": admin.firestore.FieldValue.increment(-1) });
    }

    return;
});

// countPostLikes - Increments the "like_count" field in a post document, which acts
// as a counter for the number of likes on the post.
// TODO: make this idempotent
// - Function is triggered when a new comment document is created in the "likes" subcollection of a post document in Firestore.
exports.countPostLikes = functions.firestore.document('groups/{groupId}/posts/{postId}/likes/{likeId}').onWrite(async (change, context) => {

    const groupId = context.params.groupId;
    const postId = context.params.postId;

    if (!change.before.exists) {
        return firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).update({ "like_count": admin.firestore.FieldValue.increment(1) });
    } else if (!change.after.exists) {
        return firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('posts').doc(postId).update({ "like_count": admin.firestore.FieldValue.increment(-1) });
    }

    return;
});

// onUserUpdated - Indexes a user on Algolia, when a user document is updated in the "users" 
// collection in Firestore.
// - Function is triggered when data changes in any of the user documents in the "users" collection in Firestore.
exports.onUserUpdated = functions.firestore.document('users/{userId}').onUpdate(async (change, context) => {

    const userId = context.params.userId;
    const docBeforeChange = change.before.data();
    const docAfterChange = change.after.data();

    if (docBeforeChange && docAfterChange) {
        var updated = false;

        const titleBefore = docBeforeChange.title;
        const titleAfter = docAfterChange.title;

        const nameBefore = docBeforeChange.display_name;
        const nameAfter = docAfterChange.display_name;

        const photoBefore = docBeforeChange.photo_url;
        const photoAfter = docAfterChange.photo_url;

        const interestsBefore = docBeforeChange.interests;
        const interestsAfter = docAfterChange.interests;

        const learnSkillBefore = Object.values(docBeforeChange.learn_skill);
        const teachSkillBefore = Object.values(docBeforeChange.teach_skill);
        const learnSkillAfter = Object.values(docAfterChange.learn_skill);
        const teachSkillAfter = Object.values(docAfterChange.teach_skill);

        if (titleBefore !== titleAfter || nameBefore !== nameAfter || photoBefore !== photoAfter) {
            const groupIds = await firestore.collection(USER_COLLECTION).doc(userId).collection('groups').get().then((querySnapshot) => {
                return querySnapshot.docs.map((doc) => doc.id);
            }).catch((error) => {
                console.log(error);
            });

            groupIds.forEach((id) => {
                firestore.collection(GROUPS_COLLECTION).doc(id).collection('members').doc(userId).set({
                    "title": titleAfter,
                    "display_name": nameAfter,
                    "photo_url": photoAfter,
                }, { merge: true });
            });

            updated = true;
        }

        if (interestsBefore.length === interestsAfter.length) {
            interestsBefore.forEach((interestBefore, idx) => {
                var interestAfter = interestsAfter[idx];
                if (interestBefore !== interestAfter) {
                    updated = true;
                }
            });
        } else {
            updated = true;
        }

        if (learnSkillBefore.length === learnSkillAfter.length) {
            learnSkillBefore.forEach((item, idx) => {
                var newLearnSkill = learnSkillAfter[idx];
                if (item.name !== newLearnSkill.name || item.description !== newLearnSkill.description || item.price !== newLearnSkill.price || item.duration !== newLearnSkill.duration) {
                    updated = true;
                }
            });
        } else {
            updated = true;

            if (learnSkillBefore.length > learnSkillAfter.length) {
                var learnSkillReordered = {}
                learnSkillAfter.forEach((skill, index) => learnSkillReordered[index.toString()] = skill);

                firestore.collection(USER_COLLECTION).doc(userId).update({ "learn_skill": learnSkillReordered }).catch((error) => {
                    console.log(`Error reordering skills: ${error}`);
                });
            }
        }

        if (teachSkillBefore.length === teachSkillAfter.length) {
            teachSkillBefore.forEach((item, idx) => {
                var newTeachSkill = teachSkillAfter[idx];
                if (item.name !== newTeachSkill.name || item.description !== newTeachSkill.description || item.price !== newTeachSkill.price || item.duration !== newTeachSkill.duration) {
                    updated = true;
                }
            });
        } else {
            updated = true;

            if (teachSkillBefore.length > teachSkillAfter.length) {
                var teachSkillReordered = {}
                teachSkillAfter.forEach((skill, index) => teachSkillReordered[index.toString()] = skill);

                firestore.collection(USER_COLLECTION).doc(userId).update({ "teach_skill": teachSkillReordered }).catch((error) => {
                    console.log(`Error reordering skills: ${error}`);
                });
            }
        }

        if (updated) {
            const record = {
                objectID: context.params.userId,
                display_name: docAfterChange.display_name,
                photo_url: docAfterChange.photo_url,
                about: docAfterChange.about,
                title: docAfterChange.title,
                teach_skill: teachSkillAfter,
                learn_skill: learnSkillAfter,
            };

            if (docAfterChange.interests) {
                record.interests = docAfterChange.interests;
            }

            if (docAfterChange.availability) {
                record.availability = docAfterChange.availability;
            }

            if (docAfterChange.time_zone) {
                record.time_zone = docAfterChange.time_zone;
            }

            // Write to the algolia index
            return collectionIndex.saveObject(record);
        }
    }
    return { 'message': 'Not updated.' };
});

const RECOMMENDATION_LIMIT = 3;
const algoliaRestrictionSettings = {
    "learn": [
        'teach_skill.name',
        'teach_skill.description'
    ],
    "teach": [
        'learn_skill.name',
        'learn_skill.description'
    ]
};
const RECENCY_FILTER = 1000 * 60 * 60 * 24 * 7; // 7 days 

// getRecommendations - Gets the recommendations for a specific user.
// - Function is called in the mobile client using the Firebase Cloud Functions SDK.
// - Function must be called while authenticated.
// 1. Query recommendation profiles by userId and date, if profiles == limit return
// 2. If less than limit recommendations, query queries collection to check if algolia queries have been made in the same day
// 3. If queries has all the current queries sent in the same day, return the existing recommendations
// 4. If queries does not have all the current queries, query algolia with the unqueried terms, write to queries and profiles collection and return the existing recommendations and the new recommendations if any
exports.getRecommendations = functions.https.onCall(async (data, context) => {

    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const uid = context.auth.uid;

    const timestamp = admin.firestore.Timestamp.now();
    const date = timestamp.toDate();

    const recommendationDocReference = firestore.collection(RECOMMENDATION_COLLECTION).doc(uid);
    const profilesReference = recommendationDocReference.collection('profiles');
    const queriesReference = recommendationDocReference.collection('queries');

    const recommendationSnapshot = await recommendationDocReference.get().then((documentSnapshot) => {
        return documentSnapshot;
    }).catch((error) => {
        console.log(error);
    });

    var recommendationData = {
        "limit": RECOMMENDATION_LIMIT,
        "last_updated": timestamp,
    };

    if (!recommendationSnapshot.exists) {

        recommendationDocReference.set(recommendationData).then(() => {
            return recommendationData;
        }).catch((error) => {
            throw new functions.https.HttpsError('unknown', error.message, error);
        });
    } else {
        recommendationData = recommendationSnapshot.data();
    }

    const limit = recommendationData['limit'];

    const [startDate, endDate] = dates.getStartAndEndDate(date);

    const existingRecommendations = await profilesReference.where('created_on', '>=', startDate).where('created_on', '<', endDate).get().then((querySnapshot) => {
        return querySnapshot.docs.map((doc) => {
            const recDoc = doc.data();
            recDoc['id'] = doc.id;
            return recDoc;
        });
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    })

    if (existingRecommendations.length === limit) {
        return existingRecommendations;
    }

    const user = (await firestore.collection(USER_COLLECTION).doc(uid).get()).data();

    const teachSkills = Object.values(user['teach_skill']).map(x => x['name']);
    const learnSkills = Object.values(user['learn_skill']).map(x => x['name']);
    const allSkills = teachSkills.concat(learnSkills);

    const existingQueries = (allSkills.length !== 0) ? await queriesReference.where('queried_on', '>=', startDate).where('queried_on', '<', endDate).where('term', 'in', allSkills).get().then((querySnapshot) => {
        return querySnapshot.docs.map((doc) => doc.data());
    }) : [];

    var unexecutedQueries = []
    teachSkills.forEach((query) => {
        const q = existingQueries.find(q => q['term'] === query);

        if (!q) {
            const newQuery = {
                "term": query,
                "type": "teach",
                "queried_on": timestamp,
            };
            unexecutedQueries.push(newQuery);
        }
    })

    learnSkills.forEach((query) => {
        const q = existingQueries.find(q => q['term'] === query);

        if (!q) {
            const newQuery = {
                "term": query,
                "type": "learn",
                "queried_on": timestamp,
            };
            unexecutedQueries.push(newQuery);
        }
    })

    if (unexecutedQueries.length === 0) {
        console.log('NO UNEXECUTED QUERIES');
        return existingRecommendations;
    }

    var newRecommendations = [];
    const recentStartDate = dates.subtractDate(date, RECENCY_FILTER).getTime();
    const recentProfiles = await profilesReference.where('created_on', '>=', recentStartDate).get().then((querySnapshot) => {
        return querySnapshot.docs.map((doc) => doc.data());
    });
    const recentProfileIds = recentProfiles.map(x => x['user_id']);

    await Promise.all(unexecutedQueries.map(async (q) => {

        const results = await collectionIndex.search(q['term'], {
            restrictSearchableAttributes: algoliaRestrictionSettings[q['type']],
            filters: `NOT user_id:${uid}`
        }).then(({ hits }) => {
            return hits;
        }).catch((error) => {
            console.log(`ALGOLIA SEARCH FAILED for ${q['term']}`)
            console.log(error);
            throw new functions.https.HttpsError('unknown', error.message, error);
        });

        results.filter(x => recentProfileIds.includes(x.objectID));
        newRecommendations = newRecommendations.concat(results);

        q['num_results'] = results.length;
        queriesReference.add(q).then(() => {
            console.log(q);
            return q
        }).catch((error) => {
            throw new functions.https.HttpsError('unknown', error.message, error);
        })
    }));

    recommendationDocReference.update({
        'last_updated': timestamp,
    }).then(() => {
        console.log('Updated recommendation');
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    })

    var recFlags = {};
    var newRecsUnique = newRecommendations.filter((entry) => {
        if (recFlags[entry.user_id]) {
            return false;
        }
        recFlags[entry.user_id] = true;
        return true;
    });

    if (newRecsUnique.length === 0) {
        return existingRecommendations;
    }

    const diff = limit - existingRecommendations.length;

    const recsToAdd = (newRecsUnique.length <= diff) ? newRecsUnique : utils.getRandom(newRecsUnique, diff);
    var allRecs = [];

    await Promise.all(recsToAdd.map(async (rec) => {

        rec['created_on'] = timestamp;
        rec['last_updated'] = timestamp;
        rec['status'] = 0;
        delete rec['objectID'];
        delete rec['_highlightResult'];

        return profilesReference.add(rec).then((docRef) => {
            rec['id'] = docRef.id;
            allRecs.push(rec);
            console.log(rec);
            return rec;
        }).catch((error) => {
            throw new functions.https.HttpsError('unknown', error.message, error);
        })
    }));

    allRecs = allRecs.concat(existingRecommendations);

    return allRecs;
})

// declineRecommendation - Declines a recommendation given to the user.
// - Function is called from the mobile client using the Firebase Cloud Functions SDk.
// - Function must be called with the user is authenticated.
exports.declineRecommendation = functions.https.onCall(async (data, context) => {

    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const uid = context.auth.uid;

    const recommendationDocReference = firestore.collection(RECOMMENDATION_COLLECTION).doc(uid);
    const profilesReference = recommendationDocReference.collection('profiles');

    const recommendationId = data.id;

    // Checking attribute.
    if (!(typeof recommendationId === 'string') || recommendationId.length === 0) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "id" containing the recommendation to update.');
    }

    return profilesReference.doc(recommendationId).update({
        "status": 2,
    }).then(() => {
        return {
            "id": recommendationId,
            "status": 2
        }
    }).catch((error) => {
        console.log(`Error - Failed to update recommendation: ${error}`)
    });
});

// acceptRecommendation - Accepts a recommendation given to the user.
// - Function is called from the mobile client using the Firebase Cloud Functions SDk.
// - Function must be called with the user is authenticated.
exports.acceptRecommendation = functions.https.onCall(async (data, context) => {

    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const uid = context.auth.uid;

    const recommendationDocReference = firestore.collection(RECOMMENDATION_COLLECTION).doc(uid);
    const profilesReference = recommendationDocReference.collection('profiles');

    const recommendationId = data.id;

    // Checking attribute.
    if (!(typeof recommendationId === 'string') || recommendationId.length === 0) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "id" containing the recommendation to update.');
    }

    return profilesReference.doc(recommendationId).update({
        "status": 1,
    }).then(() => {
        return {
            "id": recommendationId,
            "status": 1
        }
    }).catch((error) => {
        console.log(`Error - Failed to update recommendation: ${error}`)
    });
});

// createGroup - Creates a group by adding a group document to the "groups" collection.
// This function is meant to be manually called by the developer to create a group. Only
// developers can create groups right now. Users can not create groups. This functions is
// usually called when an environment is first created or if new groups need to be added.
// - Function must be called by the developer when necessary.
// Payload:
// {
//      "name": <STRING>, - REQUIRED - Name of the group
//      "id": <STRING>, - REQUIRED - The id given to the group (user generated)
//      "description": <STRING>, - REQUIRED - Description of the GROUP
//      "tags": <LIST<STRING>>, - OPTIONAL - List of tags describing the group, this is not used yet
//      "type": <STRING>, - REQUIRED - The grorup type, "public" or "private"
//      "photo_url": <STRING>, - OPTIONAL - The photo for the group must be a path to an object in Firebase storage
//      "password": <STRING>, - OPTIONAL - The password for the group, this is only required if the group type is "private"
// }
exports.createGroup = functions.https.onCall(async (data, context) => {

    const name = data.name;
    const id = data.id;
    const description = data.description;
    const tags = data.tags ? data.tags : [];
    const type = data.type;
    const photoUrl = data.photo_url;
    const password = data.password;

    // Checking attribute.
    if (name && !(typeof name === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    if (description && !(typeof description === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    if (type && !(typeof type === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    const time = admin.firestore.Timestamp.now();

    // Create document
    const doc = {
        "name": name,
        "description": description,
        "tags": tags,
        "type": type,
        "members": 0,
        "posts": 0,
        "created_on": time,
        "last_updated": time,
    };

    if (photoUrl) {
        doc["photo_url"] = photoUrl;
    }

    const existingGroup = await firestore.collection(GROUPS_COLLECTION).doc(id).get();

    if (existingGroup.exists) {
        return { "message": "Group already exists." };
    }

    await firestore.collection(GROUPS_COLLECTION).doc(id).set(doc).catch((error) => {
        throw new functions.https.HttpsError('internal', error.message, error);
    });

    if (type === "private") {
        await firestore.collection(GROUPS_COLLECTION).doc(id).collection('security').doc(id).set({
            "password": password,
        }).catch((error) => {
            throw new functions.https.HttpsError('internal', error.message, error);
        });
    }

    return doc;
});

// joinGroup - Allows a user to join a group. If the group is "public", the user can
// join automatically. If the group is "private", the correct password is required.
// - Function is called in the mobile client using the Firebase Cloud Functions SDK.
// - Function must be called with the user is authenticated.
// Payload:
// {
//      "group_id": <STRING>, - REQUIRED - The group ID
//      "access_code": <STRING>, - OPTIONAL - The access code to join the group, only required if the group is "private"
// }
exports.joinGroup = functions.https.onCall(async (data, context) => {

    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const userId = context.auth.uid;
    const groupId = data.group_id;
    const accessCode = data.access_code;

    // Checking attribute.
    if (groupId && !(typeof groupId === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "groupId" containing the group to join.');
    }

    const group = await firestore.collection(GROUPS_COLLECTION).doc(groupId).get().then((docSnapshot) => {
        if (!docSnapshot.exists) {
            return null;
        }
        return docSnapshot.data();
    }, (error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (group === null) {
        return { "status": "failure", "message": "The group does not exist." };
    }

    var validated = true;
    var error;
    var temp = {};

    // Check if group is private and verify access code
    if (group.type === 'private') {
        validated = await firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('security').doc(groupId).get().then((documentSnapshot) => {
            if (documentSnapshot.empty) {
                throw new Error("Access code not available.");
            }

            const data = documentSnapshot.data();
            return data.password === accessCode;
        }).catch((e) => {
            validated = false;
            error = e;
            throw new functions.https.HttpsError('internal', e.message, e);
        });
    }

    if (!validated) {
        var response = { "status": "failure", "message": "Access code is incorrect." };
        if (error) {
            response['data'] = error;
        }

        return response;
    }

    // Check if user is in group members
    const isMember = await firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('members').doc(userId).get().then((docSnapshot) => {
        return docSnapshot.exists;
    }, (error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (isMember) {
        return { "status": "failure", "message": "You are already a member." };
    }

    // Get user
    const user = await firestore.collection(USER_COLLECTION).doc(userId).get().then((docSnapshot) => {
        if (!(docSnapshot.exists)) {
            throw new Error("The user does not exist.");
        }
        return docSnapshot.data();
    }, (error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    const time = admin.firestore.Timestamp.now();

    // Create group member document
    const groupMemberDoc = {
        "display_name": user.display_name,
        "title": user.title || "",
        "photo_url": user.photo_url || "",
        "joined_on": time,
    };

    // Add user to group members
    await firestore.collection(GROUPS_COLLECTION).doc(groupId).collection('members').doc(userId).set(groupMemberDoc).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    // Change this to separate trigger
    firestore.collection(GROUPS_COLLECTION).doc(groupId).update({ members: admin.firestore.FieldValue.increment(1) });

    // Create user group document
    const userGroupDoc = {
        "role": "member",
        "joined_on": time,
    };

    // Add group to user groups
    await firestore.collection(USER_COLLECTION).doc(userId).collection('groups').doc(groupId).set(userGroupDoc).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    return { "status": "success", "data": groupMemberDoc };
});

// generateMostPopularUsers - Generate Most popular users. Start and end date on not used in the application,
// they are only used for record keeping. The "active" field determines which
// document will be accessed. The popular users are added to the "discover" collection in Firestore.
// TODO: change other documents to inactive.
// - Function is called by the developer when necessary.
exports.generateMostPopularUsers = functions.https.onRequest(async (req, res) => {

    const startDate = admin.firestore.Timestamp.now();
    var endDate = startDate.toDate();
    endDate.setTime(endDate.getTime() + (7 * 24 * 60 * 60 * 1000));

    const doc = {
        "start_date": startDate,
        "end_date": endDate,
        "active": true
    };

    const id = utils.generateUniqueFirestoreId();
    const docRef = firestore.collection(DISCOVER_COLLECTION).doc(id);

    await docRef.set(doc).catch((error) => {
        console.log(error);
    });

    var requestCount = {};
    await firestore.collection(REQUEST_COLLECTION).get().then((querySnapshot) => {

        querySnapshot.forEach((docSnapshot) => {
            const data = docSnapshot.data();

            const userId = data.receiver_id;
            const skill = data.skill;
            const price = data.price;
            const duration = data.duration;

            if (userId !== undefined && skill !== undefined && skill !== "" && price !== undefined && duration !== undefined) {
                const key = `${userId}-${skill}`;
                if (key in requestCount) {
                    const count = requestCount[key]["count"];
                    requestCount[key]["count"] = count + 1;
                } else {
                    requestCount[key] = {
                        "user_id": userId,
                        "skill": skill,
                        "price": price,
                        "duration": duration,
                        "count": 1
                    };
                }
            }
        });
        return;
    });

    var requestCountList = Object.values(requestCount);
    requestCountList.sort((a, b) => b["count"] - a["count"]);

    if (requestCountList.length > 5) {
        requestCountList = requestCountList.slice(0, 5);
    }

    const userCollection = docRef.collection('users');

    var batch = firestore.batch();

    for (let [index, val] of requestCountList.entries()) {
        const userDoc = {
            "user_id": val["user_id"],
            "rank": index + 1,
            "name": val["skill"],
            "price": val["price"],
            "duration": val["duration"]
        };

        batch.set(userCollection.doc(), userDoc);
    }

    return batch.commit().then(() => {
        res.status(200).send("Successfully generated most popular users.");
        return;
    }).catch((error) => {
        console.log(error);
        res.status(500).send(error);
        return;
    });
});