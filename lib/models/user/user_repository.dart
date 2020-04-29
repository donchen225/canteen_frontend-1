import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  // Sign in with credentials
  Future<void> signInWithCredentials(String email, String password) async {}

  /// Sign up a new user
  Future<void> signUp({String email, String password}) async {}

  Future<void> signOut() async {}

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUser(String id) async {}

  Future<User> currentUser() async {}

  User currentUserNow() {}

  // Get the User and listen to all future changes
  Stream<User> getCurrentUser(String userId) {}

  Future<List<User>> getAllUsers() async {}

  Future<FirebaseUser> getFirebaseUser() async {}

  Future<void> updateUserSignInTime(FirebaseUser user) async {}

  Future<void> updateName(String name) {}

  Future<void> updateTitle(String title) {}

  Future<void> updateAbout(String updatedText) {}

  Future<void> updateTeachSkill(Skill skill, int index) {}

  Future<void> updateLearnSkill(Skill skill, int index) {}

  Future<void> updatePhoto(String url) async {}

  Future<void> updateUserOnboarding(String name, Skill skill) async {}

  Future<void> saveToken(String token) {}
}
