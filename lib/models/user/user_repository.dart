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

  /// Only use this if necessary, first check FirebaseUser in
  /// Authentication state
  Future<FirebaseUser> getFirebaseUser() async {}

  Future<void> updateUserSignInTime(FirebaseUser user) async {}

  Future<void> updateDisplayName(String id, String name) async {}

  User updateAbout(String updatedText) {}

  Future<void> updatePhoto(String id, String url) async {}
}
