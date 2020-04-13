import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MatchEntity extends Equatable {
  final String id;
  final List<String> userId;
  final int status;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const MatchEntity(
      {@required this.id,
      @required this.userId,
      @required this.status,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }

  @override
  List<Object> get props => [id, userId, status, createdOn, lastUpdated];

  @override
  String toString() {
    return 'MatchEntity { id: $id, userId: $userId, status: $status, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static MatchEntity fromJson(Map<String, Object> json) {
    return MatchEntity(
      id: json['id'] as String,
      userId: json['user_id'] as List<String>,
      status: json['status'] as int,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snapshot) {
    return MatchEntity(
      id: snapshot.documentID,
      userId: snapshot.data['user_id'].map<String>((x) => x as String).toList(),
      status: snapshot.data['status'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'status': status,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
