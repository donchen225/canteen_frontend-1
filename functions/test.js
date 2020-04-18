// const admin = require('firebase-admin');
// const algoliasearch = require('algoliasearch');
// const cacheCommon = require('@algolia/cache-common');
// const dates = require('./date');
// const utils = require('./utils');

// const credential = require('/Users/bhsu/home/canteen/canteen_frontend/get-canteen-e465fefb3c67.json')

// const REQUEST_COLLECTION = 'requests';
// const RECOMMENDATION_COLLECTION = 'recommendations';
// const USER_COLLECTION = 'users';

// admin.initializeApp({ credential: admin.credential.cert(credential), databaseURL: "https://get-canteen.firebaseio.com" });

// const firestore = admin.firestore();

// const algoliaClient = algoliasearch('J79ENQAH4O', '3f3b46623e59fae87455170035b6d243',
//     {
//         // Caches responses from Algolia
//         responsesCache: cacheCommon.createNullCache(),

//         // Caches Promises with the same request payload
//         requestsCache: cacheCommon.createNullCache(),
//     });
// const collectionIndex = algoliaClient.initIndex('users_dev');

// const uid = "GTJZfikjbUTgOMNcTYD4nmkYEgB2";

// const timestamp = admin.firestore.Timestamp.now();
// const date = timestamp.toDate();

// const RECOMMENDATION_LIMIT = 3;
// const algoliaRestrictionSettings = {
//     "learn": [
//         'teach_skill.name',
//         'teach_skill.description'
//     ],
//     "teach": [
//         'learn_skill.name',
//         'learn_skill.description'
//     ]
// };
// const RECENCY_FILTER = 1000 * 60 * 60 * 24 * 7; // 7 days 

// const recommendationDocReference = firestore.collection(RECOMMENDATION_COLLECTION).doc(uid);
// const profilesReference = recommendationDocReference.collection('profiles');
// const queriesReference = recommendationDocReference.collection('queries');

// const output = (async () => {
//     console.log('INSIDE FUNCTION');

//     const recommendationData = await recommendationDocReference.get().then((documentSnapshot) => {

//         // Create recommendations if doesn't exist
//         if (!documentSnapshot.exists) {
//             console.log('DOCUMENT DOESNT EXIST');

//             const recommendationDoc = {
//                 "limit": RECOMMENDATION_LIMIT,
//                 "last_updated": timestamp,
//             }

//             return recommendationDocReference.set(recommendationDoc).then(() => {
//                 return recommendationDoc;
//             }).catch((error) => {
//                 throw new functions.https.HttpsError('unknown', error.message, error);
//             });
//         }

//         return documentSnapshot.data();
//     }).catch((error) => {
//         console.log(error);
//     });

//     console.log(recommendationData);

//     const limit = recommendationData['limit'];

//     const [startDate, endDate] = dates.getStartAndEndDate(date);

//     const existingRecommendations = await profilesReference.where('created_on', '>=', startDate).where('created_on', '<', endDate).get().then((querySnapshot) => {
//         return querySnapshot.docs.map((doc) => doc.data());
//     }).catch((error) => {
//         throw new functions.https.HttpsError('unknown', error.message, error);
//     })

//     console.log(`EXISTING RECOMMENDATIONS: ${existingRecommendations.length}`);

//     if (existingRecommendations.length === limit) {
//         return existingRecommendations;
//     }

//     const user = (await firestore.collection(USER_COLLECTION).doc(uid).get()).data();


//     const teachSkills = Object.values(user['teach_skill']).map(x => x['name']);
//     const learnSkills = Object.values(user['learn_skill']).map(x => x['name']);
//     const allSkills = teachSkills.concat(learnSkills);

//     console.log(teachSkills);
//     console.log(learnSkills);
//     console.log(allSkills);

//     const existingQueries = await queriesReference.where('queried_on', '>=', startDate).where('queried_on', '<', endDate).where('term', 'in', allSkills).get().then((querySnapshot) => {
//         return querySnapshot.docs.map((doc) => doc.data());
//     });

//     console.log(existingQueries);

//     var unexecutedQueries = []
//     teachSkills.forEach((query) => {
//         const q = existingQueries.find(q => q['term'] == query);

//         if (!q) {
//             const newQuery = {
//                 "term": query,
//                 "type": "teach",
//                 "queried_on": timestamp,
//             };
//             unexecutedQueries.push(newQuery);
//         }
//     })

//     learnSkills.forEach((query) => {
//         const q = existingQueries.find(q => q['term'] == query);

//         if (!q) {
//             const newQuery = {
//                 "term": query,
//                 "type": "learn",
//                 "queried_on": timestamp,
//             };
//             unexecutedQueries.push(newQuery);
//         }
//     })

//     if (unexecutedQueries.length === 0) {
//         console.log('NO UNEXECUTED QUERIES');
//         return existingRecommendations;
//     }

//     console.log(unexecutedQueries);

//     var newRecommendations = [];
//     const recentStartDate = dates.subtractDate(date, RECENCY_FILTER).getTime();
//     const recentProfiles = await profilesReference.where('created_on', '>=', recentStartDate).get().then((querySnapshot) => {
//         return querySnapshot.docs;
//     });
//     const recentProfileIds = recentProfiles.map(x => x['user_id']);

//     const idFilter = `user_id:${uid}`;
//     console.log(idFilter);

//     await Promise.all(unexecutedQueries.map(async (q) => {
//         console.log(q['term']);
//         console.log(q['type']);

//         console.log(algoliaRestrictionSettings[q['type']]);
//         const results = await collectionIndex.search(q['term'], {
//             restrictSearchableAttributes: algoliaRestrictionSettings[q['type']],
//             filters: `NOT user_id:${uid}`
//         }).then(({ hits }) => {
//             return hits;
//         }).catch((error) => {
//             console.log(`ALGOLIA SEARCH FAILED for ${q['term']}`)
//             console.log(error);
//         });

//         console.log(`before filter results: ${results}`);
//         results.filter(x => recentProfileIds.includes(x.objectID));
//         console.log(`after filter results: ${results}`);
//         newRecommendations = newRecommendations.concat(results);

//         q['num_results'] = results.length;
//         queriesReference.doc().set(q).then(() => {
//             console.log(q);
//             return q
//         }).catch((error) => {
//             throw new functions.https.HttpsError('unknown', error.message, error);
//         })
//     }));

//     console.log(`NEW RECS: ${newRecommendations}`);

//     recommendationDocReference.update({
//         'last_updated': timestamp,
//     }).then(() => {
//         console.log('Updated recommendation');
//     }).catch((error) => {
//         throw new functions.https.HttpsError('unknown', error.message, error);
//     })

//     if (newRecommendations.length === 0) {
//         return existingRecommendations;
//     }

//     const diff = limit - existingRecommendations.length;

//     const recsToAdd = (newRecommendations.length <= diff) ? newRecommendations : utils.getRandom(newRecommendations, diff);
//     var allRecs = [];
//     recsToAdd.forEach((rec) => {

//         rec['created_on'] = timestamp;
//         rec['last_updated'] = timestamp;
//         rec['status'] = 0;
//         delete rec['objectID'];
//         delete rec['_highlightResult'];

//         profilesReference.doc().set(rec).then(() => {
//             allRecs.push(rec);
//             console.log(rec);
//         }).catch((error) => {
//             throw new functions.https.HttpsError('unknown', error.message, error);
//         })
//     })

//     allRecs.concat(existingRecommendations);

//     return allRecs;
// })().then((d) => { console.log(d) });