'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

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