import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/models.dart';

class AuthBloc extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser _user;
  UserData _userData;
  String _userType = '';

  //USER GETTER
  FirebaseUser get user => _user;

  //USER SETTER
  set user(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  //USER TYPE GETTER
  String get userType => _userType;

  //USER TYPE SETTER
  set userType(String val) {
    _userType = val;
    notifyListeners();
  }

  //USER DATA GETTER
  UserData get userData => _userData;

  //USER DATA SETTER
  set userData(UserData data) {
    _userData = data;
    notifyListeners();
  }

  Future<AuthenticationResult> signIn(
      {String email, String password, String type}) async {
    userType = type;

    // User Login
    final loginResult = await firebaseLogin(email, password);
    if (loginResult != null) {
      user = loginResult;
    } else {
      return AuthenticationResult(message: 'Login Failed', result: false);
    }

    // Check Email Verification
    if (await isEmailVerified() == false) {
      return AuthenticationResult(
          message: 'Please Verify Your Email', result: false);
    }

    // Get DB Data
    bool dataResult = await getDbData(userType: userType, uid: user.uid);
    if (dataResult == true) {
      return AuthenticationResult(
          message:
              'Login Successful => ${userData.email} (${userData.userType})',
          result: true);
    } else {
      await firebaseSignOut();
      return AuthenticationResult(
          message: 'Login Failed! Please Try Again', result: false);
    }
  }

  Future<AuthenticationResult> signUp(
      {String email, String password, String username, String type}) async {
    userType = type;

    // Create User
    try {
      final signUpResult = await createUser(email, password);
      print(signUpResult);
      user = signUpResult;
    } catch (err) {
      return AuthenticationResult(message: err.message, result: false);
    }

    // Send Email Verification
    await sendEmailVerification();

    // Add User in DB
    bool result = await addUserInDb(
        email: email, uid: user.uid, userType: userType, username: username);
    if (result == true) {
      return AuthenticationResult(
          message: 'Registration Successful! Please check your email',
          result: true);
    } else {
      return AuthenticationResult(
          message: 'Failed to Register user.', result: false);
    }
  }

  // FIREBASE AUTH FUNCTIONS
  Future<FirebaseUser> firebaseLogin(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null) {
      return result.user;
    } else {
      return null;
    }
  }

  Future<FirebaseUser> createUser(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null) {
      return result.user;
    } else {
      return null;
    }
  }

  Future<void> firebaseSignOut() async {
    user = null;
    userType = null;
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    return user.isEmailVerified;
  }
  // FIREBASE AUTH FUNCTIONS END

  // FIRESTORE FUNCTIONS
  Future<bool> addUserInDb(
      {String email, String uid, String username, String userType}) async {
    try {
      await _firestore.collection('$userType').document('$uid').setData({
        'email': email,
        'uid': uid,
        'username': username,
        'userType': userType,
      });
      return true;
    } catch (err) {
      print("ERROR");
      print(err);
      return false;
    }
  }

  Future<bool> getDbData({String userType, String uid}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('$userType').document('$uid').get();
    if (snapshot.exists) {
      final data = snapshot.data;
      userData = UserData(
        email: data['email'],
        uid: data['uid'],
        userType: data['userType'],
        username: data['username'],
      );
      return true;
    } else {
      return false;
    }
  }
}
