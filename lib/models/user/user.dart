import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  final String providerId;
  final String id;
  final String displayName;
  final String photoUrl;
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
    this.photoUrl = '',
    this.email = '',
    this.phoneNumber = '',
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.isAnonymous,
    this.isEmailVerified,
  });

  @override
  String toString() {
    return 'User {providerId: $providerId, id: $id, displayName: $displayName, photoUrl: $photoUrl, email: $email, phoneNumber: $phoneNumber }';
  }

  static User fromEntity(UserEntity entity) {
    return User(
      entity.providerId,
      entity.id,
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
}
