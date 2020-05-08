import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LikeEntity extends Equatable {
  final String id;
  final String from;
  final DateTime createdOn;

  const LikeEntity(
      {@required this.id, @required this.from, @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [id, from, createdOn];

  @override
  String toString() {
    return 'LikeEntity { id: $id, from: $from, createdOn: $createdOn }';
  }

  static LikeEntity fromSnapshot(DocumentSnapshot snapshot) {
    return LikeEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      createdOn: snapshot.data["created_on"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'from': from,
      'created_on': createdOn,
    };
  }
}
