import 'package:algolia/algolia.dart';
import 'package:canteen_frontend/models/availability/availability.dart';
import 'package:canteen_frontend/models/recommendation/recommendation.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  final String providerId;
  final String id;
  final String displayName;
  final String title;
  final String about;
  final String photoUrl;
  final List<String> interests;
  final List<Skill> learnSkill;
  final List<Skill> teachSkill;
  final String email;
  final String phoneNumber;
  final int onBoarded;
  final Availability availability;
  final int timeZone;
  final DateTime creationTimestamp;
  final DateTime lastSignInTimestamp;
  final bool isAnonymous;
  final bool isEmailVerified;

  User({
    this.providerId,
    this.id,
    this.displayName = '',
    this.title = '',
    this.about = '',
    this.photoUrl = '',
    this.interests = const [],
    this.learnSkill = const [],
    this.teachSkill = const [],
    this.email = '',
    this.phoneNumber = '',
    this.onBoarded = 0,
    this.availability,
    this.timeZone = 0,
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.isAnonymous,
    this.isEmailVerified,
  });

  @override
  String toString() {
    return 'User { providerId: $providerId, id: $id, displayName: $displayName, title: $title, about: $about, photoUrl: $photoUrl, interests: $interests, learnSkill: $learnSkill, teachSkill: $teachSkill, email: $email, phoneNumber: $phoneNumber, onBoarded: $onBoarded, availability: $availability, timeZone: $timeZone }';
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
      providerId: entity.providerId,
      id: entity.id,
      displayName: entity.displayName,
      title: entity.title,
      about: entity.about,
      photoUrl: entity.photoUrl,
      interests: entity.interests,
      learnSkill: learnSkillList,
      teachSkill: teachSkillList,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      onBoarded: entity.onBoarded,
      availability: Availability.fromMap(entity.availability,
          offset: entity.timeZone ?? 0),
      timeZone: entity.timeZone,
      creationTimestamp: entity.creationTimestamp,
      lastSignInTimestamp: entity.lastSignInTimestamp,
      isAnonymous: entity.isAnonymous,
      isEmailVerified: entity.isEmailVerified,
    );
  }

  static User fromAlgoliaSnapshot(AlgoliaObjectSnapshot snapshot) {
    return User(
      id: snapshot.objectID,
      displayName: snapshot.data['display_name'],
      photoUrl: snapshot.data['photo_url'],
      title: snapshot.data['title'],
      about: snapshot.data['about'],
      interests: snapshot.data['interests'],
      learnSkill: snapshot.data['learn_skill']
          .map<Skill>((skill) => Skill.fromEntity(
              SkillEntity.fromAlgoliaSnapshot(skill), SkillType.learn))
          .toList(),
      teachSkill: snapshot.data['teach_skill']
          .map<Skill>((skill) => Skill.fromEntity(
              SkillEntity.fromAlgoliaSnapshot(skill), SkillType.teach))
          .toList(),
    );
  }

  static User fromRecommendation(Recommendation rec) {
    return User(
      id: rec.userId,
      displayName: rec.displayName,
      about: rec.about,
      title: rec.title,
      photoUrl: rec.photoUrl,
      interests: rec.interests,
      learnSkill: rec.learnSkill,
      teachSkill: rec.teachSkill,
    );
  }

  User updateAbout(String updatedText) {
    return User(
      providerId: providerId,
      id: id,
      displayName: displayName,
      title: title,
      about: updatedText,
      photoUrl: photoUrl,
      interests: interests,
      learnSkill: learnSkill,
      teachSkill: teachSkill,
      email: email,
      phoneNumber: phoneNumber,
      onBoarded: onBoarded,
      availability: availability,
      timeZone: timeZone,
      creationTimestamp: creationTimestamp,
      lastSignInTimestamp: lastSignInTimestamp,
      isAnonymous: isAnonymous,
      isEmailVerified: isEmailVerified,
    );
  }

  User updateName(String updatedText) {
    return User(
      providerId: providerId,
      id: id,
      displayName: updatedText,
      title: title,
      about: about,
      photoUrl: photoUrl,
      interests: interests,
      learnSkill: learnSkill,
      teachSkill: teachSkill,
      email: email,
      phoneNumber: phoneNumber,
      onBoarded: onBoarded,
      availability: availability,
      timeZone: timeZone,
      creationTimestamp: creationTimestamp,
      lastSignInTimestamp: lastSignInTimestamp,
      isAnonymous: isAnonymous,
      isEmailVerified: isEmailVerified,
    );
  }

  User updateTeachSkill(Skill skill, int index) {
    var teachSkills = teachSkill;
    if (teachSkills.length == index) {
      teachSkills.add(skill);
    } else {
      teachSkills[index] = skill;
    }

    return User(
      providerId: providerId,
      id: id,
      displayName: displayName,
      title: title,
      about: about,
      photoUrl: photoUrl,
      interests: interests,
      learnSkill: learnSkill,
      teachSkill: teachSkills,
      email: email,
      phoneNumber: phoneNumber,
      onBoarded: onBoarded,
      availability: availability,
      timeZone: timeZone,
      creationTimestamp: creationTimestamp,
      lastSignInTimestamp: lastSignInTimestamp,
      isAnonymous: isAnonymous,
      isEmailVerified: isEmailVerified,
    );
  }

  User updateLearnSkill(Skill skill, int index) {
    var learnSkills = learnSkill;
    if (learnSkills.length == index) {
      learnSkills.add(skill);
    } else {
      learnSkills[index] = skill;
    }

    return User(
      providerId: providerId,
      id: id,
      displayName: displayName,
      title: title,
      about: about,
      photoUrl: photoUrl,
      interests: interests,
      learnSkill: learnSkills,
      teachSkill: teachSkill,
      email: email,
      phoneNumber: phoneNumber,
      onBoarded: onBoarded,
      availability: availability,
      timeZone: timeZone,
      creationTimestamp: creationTimestamp,
      lastSignInTimestamp: lastSignInTimestamp,
      isAnonymous: isAnonymous,
      isEmailVerified: isEmailVerified,
    );
  }
}
