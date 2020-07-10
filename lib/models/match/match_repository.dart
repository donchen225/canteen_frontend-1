import 'dart:async';

import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/message/message_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:tuple/tuple.dart';

class MatchRepository {
  final matchCollection = Firestore.instance.collection('matches');
  static const String messages = "messages";
  List<DetailedMatch> _detailedMatches = [];

  MatchRepository();

  List<DetailedMatch> currentDetailedMatches() {
    return _detailedMatches;
  }

  void clearMatches() {
    _detailedMatches = [];
  }

  void saveDetailedMatch(DetailedMatch match) {
    var idx = 0;
    while (idx < _detailedMatches.length) {
      if (match.lastUpdated.isAfter(_detailedMatches[idx].lastUpdated)) {
        break;
      }

      idx++;
    }
    _detailedMatches.insert(idx, match);
  }

  void updateDetailedMatch(DocumentChangeType type, Match match) {
    if (type == DocumentChangeType.modified) {
      _detailedMatches.removeWhere((m) => m.id == match.id);
      _detailedMatches.insert(0, match);
    } else if (type == DocumentChangeType.removed) {
      _detailedMatches.removeWhere((match) => match.id == match.id);
    }
  }

  Future<void> sendMessage(String matchId, Message message) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
        matchCollection.document(matchId).collection(messages).document(),
        message.toEntity().toDocument(),
      );

      await tx.update(matchCollection.document(matchId), {
        "last_updated": message.timestamp,
      });
    });
  }

  Future<Message> getMessage(String matchId, DateTime dateTime) {
    try {
      return matchCollection
          .document(matchId)
          .collection(messages)
          .where("timestamp", isEqualTo: Timestamp.fromDate(dateTime))
          .limit(1)
          .getDocuments()
          .then((doc) {
        return Message.fromEntity(MessageEntity.fromSnapshot(
          doc.documents.first,
        ));
      });
    } catch (e) {
      print("ERROR: NO MESSAGE FOUND - $e");
    }
  }

  Stream<List<Tuple2<DocumentChangeType, Match>>> getMatches() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    return matchCollection
        .where("user_id", arrayContains: userId)
        .orderBy("last_updated", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documentChanges
          .map((doc) => Tuple2<DocumentChangeType, Match>(doc.type,
              Match.fromEntity(MatchEntity.fromSnapshot(doc.document))))
          .toList();
    });
  }

  Future<Match> getMatch(String matchId) {
    return matchCollection.document(matchId).get().then((documentSnapshot) {
      return Match.fromEntity(MatchEntity.fromSnapshot(documentSnapshot));
    });
  }

  Stream<List<Message>> getMessages(String matchId) {
    return matchCollection
        .document(matchId)
        .collection(messages)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<Message>> sink) {
          sink.add(
            snapshot.documents
                .map((doc) =>
                    Message.fromEntity(MessageEntity.fromSnapshot(doc)))
                .toList(),
          );
        },
      ),
    );
  }

  Future<List<Message>> getPreviousMessages(
      String matchId, Message message) async {
    DocumentSnapshot lastMessage = await matchCollection
        .document(matchId)
        .collection(messages)
        .document(message.id)
        .get();
    return (await matchCollection
            .document(matchId)
            .collection(messages)
            .startAfterDocument(lastMessage)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .getDocuments())
        .documents
        .map((doc) => Message.fromEntity(MessageEntity.fromSnapshot(doc)))
        .toList();
  }

  Future<void> confirmPayment(Match match) async {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(matchCollection.document(match.id), {"status": 1});
    });
  }
}
