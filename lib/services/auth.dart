import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user object based on FirebaseUser
  User _userBasedOnFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userBasedOnFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userBasedOnFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userBasedOnFirebaseUser(user);
    } catch(e) {
      print('Error Signing in');
      print(e);
      return null;
    }
  }

  //		register with email and password
  Future registerWithEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a document in the database for the new user
      await DatabaseService(uid: user.uid).updateUserData('name', '0', 100, 0);
      return _userBasedOnFirebaseUser(user);
    } catch(e) {
      print('Error in registration');
      return null;
    }

  }

  //		sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print("error signing out");
      return null;
    }
  }
}