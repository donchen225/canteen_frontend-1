import 'dart:async';

import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class VideoChatRepository {
  final matchCollection = Firestore.instance.collection('matches');
  static const String videoChat = "video_chat";
  static const String dates = "dates";
  Map<String, List<VideoChatDate>> _videoChatDetails = {};

  VideoChatRepository();

  Future<void> addVideoChatDate(
      List<VideoChatDate> date, String matchId, String videoChatId) {
    var batch = Firestore.instance.batch();

    date.forEach((d) => batch.setData(
        matchCollection
            .document(matchId)
            .collection(videoChat)
            .document(videoChatId)
            .collection(dates)
            .document(),
        d.toEntity().toDocument()));

    return batch.commit();
  }

  Stream<List<VideoChatDate>> getVideoChatDates(
      String matchId, String videoChatId) {
    return matchCollection
        .document(matchId)
        .collection(videoChat)
        .document(videoChatId)
        .collection(dates)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) =>
              VideoChatDate.fromEntity(VideoChatDateEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
