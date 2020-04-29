import 'dart:io';

import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/user/firebase_user_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = Firestore.instance.collection('users');
  User user; // current user stored in memory
  Map<String, User> userMap = {}; // all users stored in memory
  FirebaseUser _firebaseUser; // current firebase user stored in memory

  FirebaseUserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

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
    clearFirebaseUser();
    clearUser();
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  // TODO: catch ALL transactions, transactions do NOT run offline
  Future<void> addFirebaseUser(FirebaseUser user) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.set(
          userCollection.document(user.uid),
          UserEntity.fromFirebaseUserEntity(
                  FirebaseUserEntity.fromFirebaseUser(user))
              .toDocument());
    });
  }

  Future<void> addLearnSkill(int position, SkillEntity skill) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "learn_skill": {position.toString(): skill.toDocument()}
      });
    });
  }

  Future<void> updateUserSignInTime(FirebaseUser user) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(user.uid), {
        "last_sign_in_time": user.metadata.lastSignInTime,
      });
    });
  }

  Future<void> updateUserOnboarding(
    String name,
    Skill skill,
  ) {
    final skillTypeField = '${skill.type.toString().split('.').last}_skill';
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "display_name": name,
        "onboarded": 1,
        "$skillTypeField.0.name": skill.name,
        "$skillTypeField.0.price": skill.price,
        "$skillTypeField.0.duration": skill.duration,
        "$skillTypeField.0.description": skill.description,
      });
    });
  }

  Future<void> updateAbout(String about) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "about": about,
      });
    });
  }

  Future<void> updateName(String name) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "display_name": name,
      });
    });
  }

  Future<void> updateTitle(String title) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "title": title,
      });
    });
  }

  Future<void> updateTeachSkill(Skill skill, int index) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.update(userCollection.document(_firebaseUser.uid),
          {"teach_skill.${index.toString()}": skill.toEntity().toDocument()});
    });
  }

  Future<void> updateLearnSkill(Skill skill, int index) {
    return Firestore.instance.runTransaction((Transaction tx) {
      return tx.update(userCollection.document(_firebaseUser.uid),
          {"learn_skill.${index.toString()}": skill.toEntity().toDocument()});
    });
  }

  Future<void> updatePhoto(String url) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "photo_url": url,
      });
    });
  }

  Future<void> saveToken(String token) {
    print('TOKEN: $token');
    if (token == null || token.isEmpty) {
      return null;
    }

    final ref = userCollection
        .document(_firebaseUser.uid)
        .collection('tokens')
        .document(token);

    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.get(ref).then((doc) {
        if (!(doc.exists)) {
          tx.set(ref, {
            "token": token,
            "created_on": FieldValue.serverTimestamp(),
            "platform": Platform.operatingSystem,
          });
        }
      }).catchError((error) {
        print('ERROR SAVING TOKEN: $error');
      });
    });
  }

  Future<FirebaseUser> getFirebaseUser() async {
    if (_firebaseUser != null) {
      return _firebaseUser;
    }

    final user = _firebaseAuth.currentUser();
    saveFirebaseUser(user);

    return user;
  }

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUser(String id) async {
    if (userMap.containsKey(id)) {
      return Future.value(userMap[id]);
    }

    return userCollection.document(id).get().then((snapshot) {
      return UserEntity.fromSnapshot(snapshot);
    }).then((userEntity) {
      final user = User.fromEntity(userEntity);
      saveUserMap(user);
      return user;
    });
  }

  Future<User> currentUser() async {
    if (user != null) {
      return Future.value(user);
    }
    try {
      return getUser((await getFirebaseUser()).uid);
    } catch (e) {
      print('GET USER FAILED');
      print(e);
    }
  }

  // Listens to changes for a single user ID
  Stream<User> getCurrentUser(String userId) {
    return userCollection.document(userId).snapshots().map((snapshot) {
      final user = User.fromEntity(UserEntity.fromSnapshot(snapshot));
      saveUser(user);
      return user;
    });
  }

  // TODO: remove this function
  Future<List<User>> getAllUsers() async {
    return userCollection.getDocuments().then((querySnapshot) => querySnapshot
        .documents
        .map((documentSnapshot) =>
            User.fromEntity(UserEntity.fromSnapshot(documentSnapshot)))
        .toList());
  }

  User currentUserNow() {
    return user;
  }

  void saveUser(User user) {
    user = user;
  }

  void saveUserMap(User user) {
    userMap[user.id] = user;
  }

  void clearUser() {
    user = null;
  }

  void clearUserMap() {
    userMap = {};
  }

  // TODO: remove future parameter
  void saveFirebaseUser(Future<FirebaseUser> user) async {
    _firebaseUser = await user;
  }

  void clearFirebaseUser() {
    _firebaseUser = null;
  }
}
