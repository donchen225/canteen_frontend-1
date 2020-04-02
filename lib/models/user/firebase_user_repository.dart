import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/user/firebase_user_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = Firestore.instance.collection('user');

  FirebaseUserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // TODO: apparently you have to wait a short period of time (~1-2 mins) between firestore updates, look into this
  /// Sign in a user to Firebase Authentication with email/password,
  /// and updates the last sign in time in the Firestore "user" collection
  /// If the user exists in Firebase Authentication and not in the useres collection,
  /// a new user will be created
  Future<void> signInWithCredentials(String email, String password) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up a user to Firebase Authentication with email/password,
  /// and creates a user in the Firestore users collection
  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((result) => addFirebaseUser(result.user));
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

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

  /// Only use this if necessary, first check FirebaseUser in
  /// Authentication state
  Future<FirebaseUser> getFirebaseUser() async {
    return _firebaseAuth.currentUser();
  }

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUser(String id) async {
    return userCollection
        .document(id)
        .get()
        .then((snapshot) => UserEntity.fromSnapshot(snapshot))
        .then((userEntity) => User.fromEntity(userEntity));
  }

  /// Gets the User from the "user" Firestore collection
  /// Use this when possible over getUser()
  // TODO: combine data from FirebaseUser and Firestore after adding in other types of login
  Future<User> getUserFromFirebaseUser(FirebaseUser user) async {
    return getUser(user.uid);
  }

  // Listens to changes for a single user ID
  Stream<User> getCurrentUser(String userId) {
    return userCollection.document(userId).snapshots().map((snapshot) {
      return User.fromEntity(UserEntity.fromSnapshot(snapshot));
    });
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
