import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
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
  Future<void> signUp({String email, String password, String name}) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((result) async {
      if (name != null && name.isNotEmpty) {
        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = name;
        result.user.updateProfile(info);
      }

      await addFirebaseUser(result.user, name: name);
    });
  }

  Future<void> signOut() async {
    clearFirebaseUser();
    clearUser();
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<void> addFirebaseUser(FirebaseUser user, {String name}) {
    return userCollection.document(user.uid).setData(
        UserEntity.fromFirebaseUserEntity(
                FirebaseUserEntity.fromFirebaseUser(user, name: name))
            .toDocument());
  }

  Future<void> addLearnSkill(int position, SkillEntity skill) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "learn_skill": {position.toString(): skill.toDocument()}
      });
    });
  }

  Future<void> updateUserSignInTime(FirebaseUser user) {
    return userCollection.document(user.uid).updateData({
      "last_sign_in_time": user.metadata.lastSignInTime,
    }).catchError((error) {
      print('Error updating user sign in time.');
    });
  }

  Future<void> completeOnboarding() {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "onboarded": 1,
      });
    });
  }

  Future<void> updateAbout(String about) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "about": about,
      });
    });
  }

  Future<void> updateTimeZone(int timeZoneOffset) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "time_zone": timeZoneOffset,
      });
    });
  }

  Future<void> updateName(String name) {
    CachedSharedPreferences.setString(PreferenceConstants.userName, name);
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "display_name": name,
      });
    });
  }

  Future<void> updateTitle(String title) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "title": title,
      });
    });
  }

  Future<void> updateInterests(List<String> interests) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "interests": interests,
      });
    });
  }

  Future<void> updateAvailability(
      int dayIndex, int startTimeSeconds, int endTimeSeconds) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
        "availability.$dayIndex.start_time": startTimeSeconds,
        "availability.$dayIndex.end_time": endTimeSeconds,
      });
    });
  }

  Future<void> updateTeachSkill(Skill skill, int index) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid),
          {"teach_skill.${index.toString()}": skill.toEntity().toDocument()});
    });
  }

  Future<void> updateLearnSkill(Skill skill, int index) {
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid),
          {"learn_skill.${index.toString()}": skill.toEntity().toDocument()});
    });
  }

  Future<void> deleteTeachSkill(int index) {
    return userCollection
        .document(_firebaseUser.uid)
        .updateData({"teach_skill.${index.toString()}": FieldValue.delete()});
  }

  Future<void> deleteLearnSkill(int index) {
    return userCollection
        .document(_firebaseUser.uid)
        .updateData({"learn_skill.${index.toString()}": FieldValue.delete()});
  }

  Future<void> updatePhoto(String url) {
    CachedSharedPreferences.setString(PreferenceConstants.userPhotoUrl, url);
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.update(userCollection.document(_firebaseUser.uid), {
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

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUser(String id, {bool cache = true}) async {
    if (cache) {
      if (userMap.containsKey(id)) {
        return Future.value(userMap[id]);
      }
    }

    return userCollection.document(id).get().then((snapshot) {
      if (!snapshot.exists) {
        throw Exception("User doesn't exist.");
      }
      return UserEntity.fromSnapshot(snapshot);
    }).then((userEntity) {
      final user = User.fromEntity(userEntity);
      saveUserMap(user);
      return user;
    }).catchError((error) {
      print('Failed to get user: $error');
    });
  }

  Future<User> currentUser() async {
    if (user != null) {
      return Future.value(user);
    }
    try {
      final firebaseUser = await getFirebaseUser();
      if (firebaseUser == null) {
        return null;
      }

      return getUser(firebaseUser.uid, cache: false);
    } catch (e) {
      print(e);
    }
  }

  // Listens to changes for a single user ID
  Stream<User> getCurrentUser(String userId) {
    return userCollection.document(userId).snapshots().map((snapshot) {
      final currentUser = User.fromEntity(UserEntity.fromSnapshot(snapshot));

      // This block is only the run the first time the user is fetched
      if (user == null) {
        CachedSharedPreferences.setString(
            PreferenceConstants.userPhotoUrl, currentUser.photoUrl);
        CachedSharedPreferences.setString(
            PreferenceConstants.userName, currentUser.displayName);
      }

      saveUser(currentUser);

      return currentUser;
    });
  }

  // TODO: remove this function
  Future<List<User>> getAllUsers() async {
    return userCollection.limit(10).getDocuments().then((querySnapshot) =>
        querySnapshot.documents
            .map((documentSnapshot) =>
                User.fromEntity(UserEntity.fromSnapshot(documentSnapshot)))
            .toList());
  }

  User currentUserNow() {
    return user;
  }

  void saveUser(User updatedUser) {
    user = updatedUser;
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
