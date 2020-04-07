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
  final userCollection = Firestore.instance.collection('user');
  User _user; // current user stored in memory
  FirebaseUser _firebaseUser; // current firebase user stored in memory

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

  Future<void> addLearnSkill(String id, int position, SkillEntity skill) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.update(userCollection.document(id), {
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

  Future<void> updateDisplayName(String id, String name) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(id), {
        "display_name": name,
      });
    });
  }

  User updateAbout(String about) {
    final updatedUser = _user.updateAbout(about);
    _updateAbout(about);

    return updatedUser;
  }

  Future<void> _updateAbout(String about) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(_firebaseUser.uid), {
        "about": about,
      });
    });
  }

  User updateTeachSkill(Skill skill, int index) {
    final updatedUser = _user.updateTeachSkill(skill, index);
    _updateTeachSkill(skill.toEntity(), index);

    return updatedUser;
  }

  Future<void> _updateTeachSkill(SkillEntity skill, int index) {
    return Firestore.instance.runTransaction((Transaction tx) {
      tx.update(userCollection.document(_firebaseUser.uid),
          {"teach_skill.${index.toString()}": skill.toDocument()});
    });
  }

  Future<void> updatePhoto(String id, String url) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      tx.update(userCollection.document(id), {
        "photo_url": url,
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

  void saveUser(User user) {
    _user = user;
  }

  void clearUser() {
    _user = null;
  }

  // TODO: remove future parameter
  void saveFirebaseUser(Future<FirebaseUser> user) async {
    _firebaseUser = await user;
  }

  void clearFirebaseUser() {
    _firebaseUser = null;
  }

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUser(String id) async {
    return userCollection.document(id).get().then((snapshot) {
      print('INSIDE GET USER');
      print(snapshot.metadata.isFromCache ? "LOCAL CACHE" : "SERVER");
      return UserEntity.fromSnapshot(snapshot);
    }).then((userEntity) {
      final user = User.fromEntity(userEntity);

      saveUser(user);

      return user;
    });
  }

  Future<User> _getLocalUser() async {
    return userCollection
        .document((await getFirebaseUser()).uid)
        .get(source: Source.cache)
        .then((snapshot) {
      print('INSIDE GET LOCAL USER');
      print(snapshot.metadata.isFromCache ? "LOCAL CACHE" : "SERVER");
      return UserEntity.fromSnapshot(snapshot);
    }).then((userEntity) {
      final user = User.fromEntity(userEntity);

      saveUser(user);

      return user;
    });
  }

  Future<User> currentUser() async {
    if (_user != null) {
      return Future.value(_user);
    }
    try {
      return _getLocalUser();
    } catch (e) {
      print('GET LOCAL USER FAILED');
      print(e);
      return getUser((await getFirebaseUser()).uid);
    }
  }

  User currentUserNow() {
    return _user ?? null;
  }

  String currentUserId() {
    return _user?.id ?? null;
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
}
