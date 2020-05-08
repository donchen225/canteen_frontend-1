import 'package:canteen_frontend/models/like/like_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Like extends Equatable {
  final String id;
  final String from;
  final DateTime createdOn;

  const Like({
    this.id,
    @required this.from,
    @required this.createdOn,
  });

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
    return 'Like { id: $id, from: $from, createdOn: $createdOn }';
  }

  static Like fromEntity(LikeEntity entity) {
    return Like(
      id: entity.id,
      from: entity.from,
      createdOn: entity.createdOn,
    );
  }

  LikeEntity toEntity() {
    return LikeEntity(
      id: id,
      from: from,
      createdOn: createdOn,
    );
  }
}
