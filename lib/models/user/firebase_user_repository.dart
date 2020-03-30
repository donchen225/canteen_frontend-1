import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/user/firebase_user_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository {
  final userCollection = Firestore.instance.collection('user');

  Future<void> addFirebaseUser(FirebaseUser user) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.set(userCollection.document(user.uid),
          FirebaseUserEntity.fromFirebaseUser(user).toDocument());
    });
  }

  Future<void> updateUserSignInTime(FirebaseUser user) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(user.uid), {
        "last_sign_in_time": user.metadata.lastSignInTime,
      });
    });
  }

  Future<void> updateDisplayName(String id, String name) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(id), {
        "display_name": name,
      });
    });
  }

  Future<void> updatePhoto(String id, String url) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(id), {
        "photo_url": url,
      });
    });
  }

  // Future<bool> exists(String id) async {
  //   var snapShot = await userCollection.document(id).get();

  //   return (snapShot != null && snapShot.exists);
  // }

  Future<User> getUser(String id) async {
    return userCollection
        .document(id)
        .get()
        .then((snapshot) => UserEntity.fromSnapshot(snapshot))
        .then((userEntity) => User.fromEntity(userEntity));
  }

  // TODO: make this stream based
  // TODO: clean this up
  Future<List<User>> searchUser(String identifier) async {
    var usersFromEmail = userCollection
        .where("email", isEqualTo: identifier)
        .getDocuments()
        .then((querySnapshot) => querySnapshot.documents
            .map((documentSnapshot) =>
                User.fromEntity(UserEntity.fromSnapshot(documentSnapshot)))
            .toList());
    var usersFromDisplayName = userCollection
        .where("displayName", isEqualTo: identifier)
        .getDocuments()
        .then((querySnapshot) => querySnapshot.documents
            .map((documentSnapshot) =>
                User.fromEntity(UserEntity.fromSnapshot(documentSnapshot)))
            .toList());

    return Future.wait([usersFromEmail, usersFromDisplayName])
        .then((userList) => userList.expand((i) => i).toList());
  }
}
