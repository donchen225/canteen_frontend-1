import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  final String providerId;
  final String id;
  final String displayName;
  final String about;
  final String photoUrl;
  final List<Skill> learnSkill;
  final List<Skill> teachSkill;
  final String email;
  final String phoneNumber;
  final DateTime creationTimestamp;
  final DateTime lastSignInTimestamp;
  final bool isAnonymous;
  final bool isEmailVerified;

  User(
    this.providerId,
    this.id, {
    this.displayName = '',
    this.about = '',
    this.photoUrl = '',
    this.learnSkill = const [],
    this.teachSkill = const [],
    this.email = '',
    this.phoneNumber = '',
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.isAnonymous,
    this.isEmailVerified,
  });

  @override
  String toString() {
    return 'User { providerId: $providerId, id: $id, displayName: $displayName, about: $about, photoUrl: $photoUrl, learnSkill: $learnSkill, teachSkill: $teachSkill, email: $email, phoneNumber: $phoneNumber }';
  }

  static User fromEntity(UserEntity entity) {
    var learnSkillList = (entity.learnSkills.entries.toList()
          ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key))))
        .map((entry) => entry.value)
        .toList();

    var teachSkillList = (entity.teachSkills.entries.toList()
          ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key))))
        .map((entry) => entry.value)
        .toList();

    return User(
      entity.providerId,
      entity.id,
      displayName: entity.displayName,
      about: entity.about,
      photoUrl: entity.photoUrl,
      learnSkill: learnSkillList,
      teachSkill: teachSkillList,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      creationTimestamp: entity.creationTimestamp,
      lastSignInTimestamp: entity.lastSignInTimestamp,
      isAnonymous: entity.isAnonymous,
      isEmailVerified: entity.isEmailVerified,
    );
  }
}
