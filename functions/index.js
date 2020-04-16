'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const REQUEST_COLLECTION = 'requests';

admin.initializeApp();

const firestore = admin.firestore();

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

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', uid).where('receiver_id', '==', receiverId).get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                throw new functions.https.HttpsError('already-exists', 'Request already exists.');
            }
        });
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });


    // Create document
    const doc = {
        "sender_id": uid,
        "receiver_id": receiverId,
        "skill": skill,
        "status": 0,
        "comment": comment,
        "created_on": admin.firestore.Timestamp.now(),
    };

    return firestore.collection(REQUEST_COLLECTION).doc().set(doc).then(() => {
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
});

// Create match in Firestore
exports.createMatch = functions.firestore.document('requests/{requestId}').onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    const status = previousValue.status;

    const time = admin.firestore.Timestamp.now();
    const match = {
        "user_id": [],
        "status": 0,
        "created_on": time,
        "last_updated": time,
    };

    return firestore.collection(REQUEST_COLLECTION).doc().set(doc).then(() => {
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
});


exports.addMatch = functions.https.onCall(async (data, context) => {

    // Checking that the user is authenticated.
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }

    const receiverId = data.receiver_id;
    const skill = data.skill;
    const comment = data.comment;

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

    await firestore.collection(REQUEST_COLLECTION).where('sender_id', '==', uid).where('receiver_id', '==', receiverId).get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            if (doc.exists) {
                throw new functions.https.HttpsError('already-exists', 'Request already exists.');
            }
        });
        return;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });


    // Create document
    const doc = {
        "sender_id": uid,
        "receiver_id": receiverId,
        "skill": skill,
        "status": 0,
        "comment": comment,
        "created_on": admin.firestore.Timestamp.now(),
    };

    return firestore.collection(REQUEST_COLLECTION).doc().set(doc).then(() => {
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
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
        ]
    }).then(() => {
        res.status(200).send("Algolia search attributes set successfully.");
        return;
    });
});

const ZOOM_BASE_URL = 'https://api.zoom.us/v2/';
const ZOOM_USER_ID = 'D3HzE_hfR5yJ6Kyv5QqaDA';

// Video chat functions
// exports.createRoom = functions.https.onRequest(async (req, res) => {

//     // Check if user is authenticated
//     // Check if user has paid

// });


exports.onUserCreated = functions.firestore.document('users/{userId}').onCreate((snapshot, context) => {

    if (snapshot.exists) {
        const user = snapshot.data();

        if (user) {
            if (Object.entries(user.teach_skill).length !== 0 || Object.entries(user.learn_skill).length !== 0) {
                const record = {
                    objectID: context.params.userId,
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