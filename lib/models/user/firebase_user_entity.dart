import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserEntity extends Equatable {
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

  const FirebaseUserEntity(
    this.providerId,
    this.id,
    this.displayName,
    this.photoUrl,
    this.email,
    this.phoneNumber,
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.isAnonymous,
    this.isEmailVerified,
  );

  @override
  List<Object> get props => [
        providerId,
        id,
        displayName,
        photoUrl,
        email,
        phoneNumber,
        creationTimestamp,
        lastSignInTimestamp,
        isAnonymous,
        isEmailVerified,
      ];

  static FirebaseUserEntity fromFirebaseUser(FirebaseUser user, {String name}) {
    return FirebaseUserEntity(
      user.providerId,
      user.uid,
      name ?? user.displayName,
      user.photoUrl,
      user.email,
      user.phoneNumber,
      user.metadata.creationTime,
      user.metadata.lastSignInTime,
      user.isAnonymous,
      user.isEmailVerified,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "provider_id": providerId,
      "display_name": displayName,
      "photo_url": photoUrl,
      "email": email,
      "phone_number": phoneNumber,
      "creation_time": creationTimestamp,
      "last_sign_in_time": lastSignInTimestamp,
      "is_anonymous": isAnonymous,
      "is_email_verified": isEmailVerified,
    };
  }
}
