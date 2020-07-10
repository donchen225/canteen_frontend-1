import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PopularUserEntity extends Equatable {
  final String id;
  final int rank;
  final Skill skill;

  const PopularUserEntity({
    this.id,
    this.rank,
    this.skill,
  });

  @override
  List<Object> get props => [
        id,
        rank,
        skill,
      ];

  static PopularUserEntity fromSnapshot(DocumentSnapshot snap) {
    return PopularUserEntity(
      id: snap["user_id"],
      rank: snap.data["rank"],
      skill: Skill(
        name: snap.data["name"],
        price: snap.data["price"],
        duration: snap.data["duration"],
      ),
    );
  }
}
