import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String providerId;
  final String displayName;
  final String photoUrl;
  final String email;
  final String phoneNumber;
  final DateTime creationTimestamp;
  final DateTime lastSignInTimestamp;
  final bool isAnonymous;
  final bool isEmailVerified;

  const UserEntity(
    this.id,
    this.providerId,
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
        id,
        providerId,
        displayName,
        photoUrl,
        email,
        phoneNumber,
        creationTimestamp,
        lastSignInTimestamp,
        isAnonymous,
        isEmailVerified,
      ];

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.documentID,
      snap.data["provider_id"],
      snap.data["display_name"],
      snap.data["photo_url"],
      snap.data["email"],
      snap.data["phone_number"],
      snap.data["creation_time"].toDate(),
      snap.data["last_sign_in_time"].toDate(),
      snap.data["is_anonymous"],
      snap.data["is_email_verified"],
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
