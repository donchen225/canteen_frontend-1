import 'package:canteen_frontend/models/discover/popular_user_entity.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:meta/meta.dart';

@immutable
class PopularUser {
  final String id;
  final int rank;
  final Skill skill;

  PopularUser({
    this.id,
    this.rank,
    this.skill,
  });

  @override
  String toString() {
    return 'PopularUser { id: $id, rank: $rank }';
  }

  static PopularUser fromEntity(PopularUserEntity entity) {
    return PopularUser(
      id: entity.id,
      rank: entity.rank,
      skill: entity.skill,
    );
  }
}
