'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const dates = require('./date');
const zoom = require('./zoom');
const utils = require('./utils');

const REQUEST_COLLECTION = 'requests';
const MATCH_COLLECTION = 'matches';
const RECOMMENDATION_COLLECTION = 'recommendations';
const USER_COLLECTION = 'users';
const VIDEO_CHAT_COLLECTION = 'video_chat';

admin.initializeApp();

const firestore = admin.firestore();
const fcm = admin.messaging();

// Create request in Firestore
exports.addRequest = functions.https.onCall(async (data, context) => {

    // Checking that the user is authenticated.
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const receiverId = data.receiver_id;
    const skill = data.skill;
    const comment = data.comment;

    var output = {};
    var terminate = false;

    // Checking attribute.
    if (!(typeof receiverId === 'string') || receiverId.length === 0) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    if (skill && !(typeof skill === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    if (comment && !(typeof comment === 'string')) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }

    // [START authIntegration]
    // Authentication / user information is automatically added to the request.
    const uid = context.auth.uid;
    const name = context.auth.token.name || null;
    const picture = context.auth.token.picture || null;
    const email = context.auth.token.email || null;
    // [END authIntegration]

    // [START returnMessageAsync]
    if (receiverId === uid) {
        throw new functions.https.HttpsError('invalid-argument', 'The user ID cannot be same as sender ID.');
    }

    await firestore.collection('users').doc(receiverId).get().then((doc) => {
        if (!doc.exists) {
            throw new functions.https.HttpsError('invalid-argument', 'The user ID cannot be same as sender ID.');
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', uid).where('receiver_id', '==', receiverId).where('status', '==', 0).get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                terminate = true;
                output = { 'status': 'SKIPPED', 'message': 'Request already exists.' };
                return;
            }
        });
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (terminate) {
        return output;
    }

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', receiverId).where('receiver_id', '==', uid).where('status', '==', 0).get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                terminate = true;
                output = { 'status': 'SKIPPED', 'message': 'Request already exists.' };
                return;
            }
        });
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
            output = { 'status': 'SKIPPED', 'message': 'Match already exists.' };
            return;
        }
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    if (terminate) {
        return output;
    }

    // Create document
    const doc = {
        "sender_id": uid,
        "receiver_id": receiverId,
        "skill": skill,
        "status": 0,
        "comment": comment,
        "created_on": admin.firestore.Timestamp.now(),
    };

    return firestore.collection(REQUEST_COLLECTION).add(doc).then(() => {
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
});

// Create match in Firestore
exports.createMatch = functions.firestore.document('requests/{requestId}').onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    const oldStatus = previousValue.status;
    const newStatus = newValue.status;

    if (oldStatus === newStatus || newStatus !== 1) {
        return { 'status': 'SKIPPED', 'message': 'Status condition not met.' };
    }

    const time = admin.firestore.Timestamp.now();

    const matchId = (utils.hashCode(previousValue.sender_id) < utils.hashCode(previousValue.receiver_id)) ? previousValue.sender_id + previousValue.receiver_id : previousValue.receiver_id + previousValue.sender_id;
    const videoChatId = context.eventId;

    const match = {
        "user_id": [previousValue.sender_id, previousValue.receiver_id],
        "status": 0,
        "created_on": time,
        "last_updated": time,
        "active_video_chat": videoChatId,
    };

    const matchRef = firestore.collection(MATCH_COLLECTION).doc(matchId);

    const create = shouldCreate(matchRef);

    if (!create) {
        return {};
    }

    await matchRef.set(match, { merge: true }).then(() => {
        return match;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    // Add video chat session
    matchRef.collection(VIDEO_CHAT_COLLECTION).doc(videoChatId).set({
        "last_updated": time,
    }, { merge: true }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });

    return match;

    function shouldCreate(matchRef) {
        return matchRef.get().then(matchDoc => {
            return !matchDoc.exists;
        });
    }
});

// Set up Algolia.
const algoliaClient = algoliasearch(functions.config().algolia.appid, functions.config().algolia.apikey);
// const collectionIndexName = functions.config().projectId === 'PRODUCTION-PROJECT-NAME' ? 'COLLECTION_prod' : 'COLLECTION_dev';
const collectionIndex = algoliaClient.initIndex('users_dev');

// Create a HTTP request cloud function.
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
            teach_skill: Object.values(document.teach_skill),
            learn_skill: Object.values(document.learn_skill),
        };

        algoliaRecords.push(record);
    });

    // After all records are created, we save them to 
    collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
        res.status(200).send("COLLECTION was indexed to Algolia successfully.");
    });

})

exports.setAlgoliaSearchAttributes = functions.https.onRequest(async (req, res) => {

    return collectionIndex.setSettings({
        searchableAttributes: [
            'teach_skill.name',
            'learn_skill.name',
            'teach_skill.description',
            'learn_skill.description',
        ],
        attributesForFaceting: [
            'filterOnly(user_id)',
        ],
    }).then(() => {
        res.status(200).send("Algolia search attributes set successfully.");
        return;
    });
});

// Video chat functions
exports.createVideoChatRoom = functions.https.onRequest(async (data, context) => {

    // Check if user is authenticated
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    // Check if match exists

    // Check if user has paid

    // Check if zoom has already been created, if it has return that link instead

    // Check if date has been accepted

    // Validate zoom parameters

    var response = await zoom.sendZoomRequest('topic', 'agenda', 'time', 'duration');

    // Write response to Firestore
    return await firestore.collection(VIDEO_CHAT_COLLECTION).add(response).then((doc) => {
        return { 'zoom_url': doc['join_url'] };
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    })

});


exports.onUserCreated = functions.firestore.document('users/{userId}').onCreate((snapshot, context) => {

    if (snapshot.exists) {
        const user = snapshot.data();

        if (user) {
            if (Object.entries(user.teach_skill).length !== 0 || Object.entries(user.learn_skill).length !== 0) {
                const record = {
                    objectID: context.params.userId,
                    user_id: context.params.userId,
                    display_name: user.display_name,
                    photo_url: user.photo_url,
                    about: user.about,
                    teach_skill: Object.values(user.teach_skill),
                    learn_skill: Object.values(user.learn_skill),
                };

                // Write to the algolia index
                return collectionIndex.saveObject(record);
            }
        }
    }
    return { 'message': 'Not updated.' };
});

exports.onChatUpdated = functions.firestore.document('matches/{matchId}/messages/{messageId}').onCreate(async (snap, context) => {

    const data = snap.data();
    const matchId = context.params.matchId;

    const senderId = data.sender_id;
    const message = data.text;

    const receiverId = matchId.replace(senderId, '');

    const querySnapshot = await firestore
        .collection(USER_COLLECTION)
        .doc(receiverId)
        .collection('tokens')
        .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    if (!Array.isArray(tokens) || !tokens.length) {
        console.log("Token doesn't exist")
        return;
    }

    const sender = await firestore
        .collection(USER_COLLECTION)
        .doc(senderId).get();
    const senderData = sender.data();

    const payload = {
        notification: {
            title: senderData.display_name,
            body: message,
            // icon: 'your-icon-url',
            click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
        }
    };

    fcm.sendToDevice(tokens, payload);
});

exports.onUserUpdated = functions.firestore.document('users/{userId}').onUpdate((change, context) => {

    const docBeforeChange = change.before.data()
    const docAfterChange = change.after.data()

    if (docBeforeChange && docAfterChange) {

        const learnSkillBefore = Object.values(docBeforeChange.learn_skill);
        const teachSkillBefore = Object.values(docBeforeChange.teach_skill);
        const learnSkillAfter = Object.values(docAfterChange.learn_skill);
        const teachSkillAfter = Object.values(docAfterChange.teach_skill);

        var updated = false;

        if (learnSkillBefore.length === learnSkillAfter.length && teachSkillBefore.length === teachSkillAfter.length) {
            learnSkillBefore.forEach((item, idx) => {
                var newLearnSkill = learnSkillAfter[idx];
                if (item.name !== newLearnSkill.name || item.description !== newLearnSkill.description) {
                    updated = true;
                }
            });

            teachSkillBefore.forEach((item, idx) => {
                var newTeachSkill = teachSkillAfter[idx];
                if (item.name !== newTeachSkill.name || item.description !== newTeachSkill.description) {
                    updated = true;
                }
            });
        } else {
            updated = true;
        }

        if (updated) {
            const record = {
                objectID: context.params.userId,
                display_name: docAfterChange.display_name,
                photo_url: docAfterChange.photo_url,
                about: docAfterChange.about,
                teach_skill: teachSkillAfter,
                learn_skill: learnSkillAfter,
            };

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