import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseUserRepository _firebaseUserRepository;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseUserRepository = FirebaseUserRepository();

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
        .then((result) => _firebaseUserRepository.addFirebaseUser(result.user));
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  /// Gets the current user from Firebase Authentication and then
  /// gets the associated user from the Firestore "user" collection
  /// Only use this if necessary, first check FirebaseUser in
  /// Authentication state
  Future<User> getUser() async {
    return _firebaseAuth.currentUser().then(
        (firebaseUser) => _firebaseUserRepository.getUser(firebaseUser.uid));
  }

  // Gets the User from the "user" Firestore collection using id
  Future<User> getUserFromId(String id) async {
    return _firebaseUserRepository.getUser(id);
  }

  /// Gets the User from the "user" Firestore collection
  /// Use this when possible over getUser()
  // TODO: combine data from FirebaseUser and Firestore after adding in other types of login
  Future<User> getUserFromFirebaseUser(FirebaseUser user) async {
    return _firebaseUserRepository.getUser(user.uid);
  }

  /// Only use this if necessary, first check FirebaseUser in
  /// Authentication state
  Future<FirebaseUser> getFirebaseUser() async {
    return _firebaseAuth.currentUser();
  }

  Future<List<User>> searchUser(String identifier) async {
    return _firebaseUserRepository.searchUser(identifier);
  }

  Future<void> updateUserSignInTime(FirebaseUser user) async {
    return _firebaseUserRepository.updateUserSignInTime(user);
  }

  Future<void> updateDisplayName(String id, String name) async {
    return _firebaseUserRepository.updateDisplayName(id, name);
  }

  Future<void> updatePhoto(String id, String url) async {
    return _firebaseUserRepository.updatePhoto(id, url);
  }
}
