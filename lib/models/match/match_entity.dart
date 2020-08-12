import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MatchEntity extends Equatable {
  final String id;
  final List<String> userId;
  final String senderId;
  final int status;
  final String payer;
  final DateTime time;
  final Map<String, bool> read;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const MatchEntity(
      {@required this.id,
      @required this.userId,
      @required this.senderId,
      @required this.status,
      @required this.payer,
      @required this.time,
      @required this.read,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'sender_id': senderId,
      'status': status,
      'payer': payer,
      'time': time,
      'read': read,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }

  @override
  List<Object> get props =>
      [id, userId, senderId, status, payer, time, read, createdOn, lastUpdated];

  @override
  String toString() {
    return 'MatchEntity { id: $id, userId: $userId, senderId: $senderId, status: $status, payer: $payer, time: $time, read: $read, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snapshot) {
    return MatchEntity(
      id: snapshot.documentID,
      userId: snapshot.data['user_id'].map<String>((x) => x as String).toList(),
      senderId: snapshot.data['sender_id'],
      status: snapshot.data['status'],
      payer: snapshot.data['payer'],
      time: snapshot.data['time']?.toDate() ?? null,
      read: snapshot.data['read']
              ?.map<String, bool>((k, v) => MapEntry(k as String, v as bool)) ??
          {},
      createdOn: snapshot.data['created_on'].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }
}
