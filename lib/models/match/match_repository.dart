import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:tuple/tuple.dart';

class MatchRepository {
  final matchCollection = Firestore.instance.collection('match');

  Future<void> addMatch(Match match) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.set(matchCollection.document(match.id), match.toEntity().toDocument());
    });
  }

  Future<void> addQuiztoMatch(String matchId, String quizId) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(matchCollection.document(matchId), {
        'quiz_id': FieldValue.arrayUnion([quizId])
      });
    });
  }

  Future<void> deleteMatch(Match match) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.delete(matchCollection.document(match.id));
    });
  }

  // Gets the match containing the userId and the opponentUserIds
  // If more than 1 match exists, an exception will be thrown
  // If no match exists, will return null
  Future<Match> getMatch(String userId, List<String> opponentUserId) async {
    try {
      var query = matchCollection.where("user_id.$userId", isEqualTo: true);
      opponentUserId.forEach((id) {
        query = query.where("user_id.$id", isEqualTo: true);
      });

      var numUsers = opponentUserId.length + 1;
      var filteredDoc = (await query.getDocuments())
          .documents
          .where((doc) => doc.data['user_id'].length == numUsers);

      if (filteredDoc.length > 1) {
        throw Exception(
            'Only 1 match should exist. Found ${filteredDoc.length} matches.');
      } else if (filteredDoc.length == 0) {
        return null;
      }

      return Match.fromEntity(MatchEntity.fromSnapshot(filteredDoc.first));
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<Tuple2<DocumentChangeType, Match>>> getAllMatches(String userId) {
    return matchCollection
        .where("user_id.$userId", isGreaterThanOrEqualTo: 0)
        .where("status", isEqualTo: 1)
        .snapshots()
        .map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Match>(doc.type,
              Match.fromEntity(MatchEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }
}
