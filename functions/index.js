'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

const REQUEST_COLLECTION = 'request';
admin.initializeApp();

// [START messageFunctionTrigger]
// Saves a message to the Firebase Realtime Database but sanitizes the text by removing swearwords.
exports.addRequest = functions.https.onCall((data, context) => {
    // [START readMessageData]
    // Message text passed from the client.
    const senderId = data.sender_id;
    const receiverId = data.receiver_id;
    const skill = data.skill;
    const status = data.status;
    const comment = data.comment;
    // [END readMessageData]
    // [START messageHttpsErrors]
    // Checking attribute.
    if (!(typeof senderId === 'string') || senderId.length === 0) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
            'one arguments "text" containing the message text to add.');
    }
    // Checking that the user is authenticated.
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }
    // [END messageHttpsErrors]

    // [START authIntegration]
    // Authentication / user information is automatically added to the request.
    const uid = context.auth.uid;
    const name = context.auth.token.name || null;
    const picture = context.auth.token.picture || null;
    const email = context.auth.token.email || null;
    // [END authIntegration]

    // [START returnMessageAsync]
    console.log(data);

    // Create document
    const doc = {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "skill": skill,
        "status": status,
        "comment": comment,
        "created_on": admin.firestore.Timestamp.now(),
    };

    return admin.firestore().collection(REQUEST_COLLECTION).doc().set(doc).then(() => {
        console.log('New Request written');
        return doc;
    }).catch((error) => {
        throw new functions.https.HttpsError('unknown', error.message, error);
    });
});
// [END messageFunctionTrigger]