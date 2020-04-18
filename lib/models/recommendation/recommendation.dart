import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:equatable/equatable.dart';

class Recommendation extends Equatable {
  final String userId;
  final String displayName;
  final String about;
  final String photoUrl;
  final List<Skill> learnSkill;
  final List<Skill> teachSkill;
  final int status;
  final DateTime lastUpdated;
  final DateTime createdOn;

  Recommendation({
    this.userId,
    this.displayName = '',
    this.about = '',
    this.photoUrl = '',
    this.learnSkill = const [],
    this.teachSkill = const [],
    this.status = 0,
    this.lastUpdated,
    this.createdOn,
  });

  static Recommendation fromJSON(Map<dynamic, dynamic> json) {
    return Recommendation(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      about: json['about'] as String,
      photoUrl: json['photo_url'] as String,
      learnSkill: json['learn_skill']
          .map<Skill>((skill) =>
              Skill.fromEntity(SkillEntity.fromAlgoliaSnapshot(skill)))
          .toList(),
      teachSkill: json['teach_skill']
          .map<Skill>((skill) =>
              Skill.fromEntity(SkillEntity.fromAlgoliaSnapshot(skill)))
          .toList(),
      status: json['status'],
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          json['last_updated']['_seconds'] * 1000),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
          json['created_on']['_seconds'] * 1000),
    );
  }

  @override
  List<Object> get props => [];
}
