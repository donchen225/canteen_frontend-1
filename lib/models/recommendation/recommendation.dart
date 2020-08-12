import 'package:canteen_frontend/models/availability/availability.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:equatable/equatable.dart';

class Recommendation extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String title;
  final String about;
  final String photoUrl;
  final List<String> interests;
  final List<Skill> learnSkill;
  final List<Skill> teachSkill;
  final Availability availability;
  final int timeZone;
  final int status;
  final DateTime lastUpdated;
  final DateTime createdOn;

  Recommendation({
    this.id,
    this.userId,
    this.displayName = '',
    this.title = '',
    this.about = '',
    this.photoUrl = '',
    this.interests = const [],
    this.learnSkill = const [],
    this.teachSkill = const [],
    this.availability,
    this.timeZone = 0,
    this.status = 0,
    this.lastUpdated,
    this.createdOn,
  });

  static Recommendation fromJSON(Map<dynamic, dynamic> json) {
    final Map<String, Map<String, int>> availability = json['availability']
            ?.map<String, Map<String, int>>((dynamic k, dynamic v) =>
                MapEntry<String, Map<String, int>>(
                    k as String,
                    v.map<String, int>(
                        (k1, v1) => MapEntry(k1 as String, v1 as int)))) ??
        {};

    return Recommendation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      title: json['title'] as String,
      about: json['about'] as String,
      photoUrl: json['photo_url'] as String,
      timeZone: json['time_zone'] as int,
      availability: json['availability'] != null && json['time_zone'] != null
          ? Availability.fromMap(availability, offset: json['time_zone'] ?? 0)
          : null,
      interests:
          json['interests']?.map<String>((x) => x.toString())?.toList() ?? [],
      learnSkill: json['learn_skill']
          .map<Skill>((skill) => Skill.fromEntity(
              SkillEntity.fromAlgoliaSnapshot(skill), SkillType.request))
          .toList(),
      teachSkill: json['teach_skill']
          .map<Skill>((skill) => Skill.fromEntity(
              SkillEntity.fromAlgoliaSnapshot(skill), SkillType.offer))
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
