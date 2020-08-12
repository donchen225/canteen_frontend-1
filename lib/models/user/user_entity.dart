import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/firebase_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String providerId;
  final String displayName;
  final String title;
  final String about;
  final String photoUrl;
  final List<String> interests;
  final Map<String, Skill> learnSkills;
  final Map<String, Skill> teachSkills;
  final String email;
  final String phoneNumber;
  final int onBoarded;
  final Map<String, Map<String, int>> availability;
  final int timeZone;
  final DateTime creationTimestamp;
  final DateTime lastSignInTimestamp;
  final bool isAnonymous;
  final bool isEmailVerified;

  const UserEntity({
    this.id,
    this.providerId,
    this.displayName = '',
    this.title = '',
    this.about = '',
    this.photoUrl = '',
    this.interests = const [],
    this.learnSkills = const {},
    this.teachSkills = const {},
    this.email = '',
    this.phoneNumber = '',
    this.onBoarded = 0,
    this.availability = const {},
    this.timeZone = 0,
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.isAnonymous,
    this.isEmailVerified,
  });

  @override
  List<Object> get props => [
        id,
        providerId,
        displayName,
        title,
        about,
        photoUrl,
        interests,
        learnSkills,
        teachSkills,
        email,
        phoneNumber,
        onBoarded,
        availability,
        timeZone,
        creationTimestamp,
        lastSignInTimestamp,
        isAnonymous,
        isEmailVerified,
      ];

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      id: snap.documentID,
      providerId: snap.data["provider_id"],
      displayName: snap.data["display_name"],
      title: snap.data["title"],
      about: snap.data["about"],
      photoUrl: snap.data["photo_url"],
      interests:
          snap.data["interests"]?.map<String>((x) => x.toString())?.toList() ??
              [],
      learnSkills: snap.data["learn_skill"]?.map<String, Skill>((k, v) =>
              MapEntry(k as String, Skill.fromMap(v, SkillType.request))) ??
          {},
      teachSkills: snap.data["teach_skill"]?.map<String, Skill>((k, v) =>
              MapEntry(k as String, Skill.fromMap(v, SkillType.offer))) ??
          {},
      email: snap.data["email"],
      phoneNumber: snap.data["phone_number"],
      onBoarded: snap.data["onboarded"],
      availability: snap.data["availability"]?.map<String, Map<String, int>>(
              (dynamic k, dynamic v) => MapEntry<String, Map<String, int>>(
                  k as String,
                  v.map<String, int>(
                      (k1, v1) => MapEntry(k1 as String, v1 as int)))) ??
          {},
      timeZone: snap.data["time_zone"],
      creationTimestamp: snap.data["creation_time"].toDate(),
      lastSignInTimestamp: snap.data["last_sign_in_time"].toDate(),
      isAnonymous: snap.data["is_anonymous"],
      isEmailVerified: snap.data["is_email_verified"],
    );
  }

  static UserEntity fromFirebaseUserEntity(FirebaseUserEntity entity) {
    return UserEntity(
      id: entity.id,
      providerId: entity.providerId,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      creationTimestamp: entity.creationTimestamp,
      lastSignInTimestamp: entity.lastSignInTimestamp,
      isAnonymous: entity.isAnonymous,
      isEmailVerified: entity.isEmailVerified,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "provider_id": providerId,
      "display_name": displayName,
      "title": title,
      "about": about,
      "photo_url": photoUrl,
      "interests": interests,
      "learn_skill": learnSkills,
      "teach_skill": teachSkills,
      "email": email,
      "phone_number": phoneNumber,
      "onboarded": onBoarded,
      "availability": availability,
      "time_zone": timeZone,
      "creation_time": creationTimestamp,
      "last_sign_in_time": lastSignInTimestamp,
      "is_anonymous": isAnonymous,
      "is_email_verified": isEmailVerified,
    };
  }
}
