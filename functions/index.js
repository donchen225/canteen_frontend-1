'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

const REQUEST_COLLECTION = 'request';

admin.initializeApp();

const firestore = admin.firestore();

// [START messageFunctionTrigger]
// Saves a message to the Firebase Realtime Database but sanitizes the text by removing swearwords.
exports.addRequest = functions.https.onCall((data, context) => {

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
        console.log('New Request written');
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
});
// [END messageFunctionTrigger]