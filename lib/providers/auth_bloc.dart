import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser _user;
  UserData _userData;
  String _userType;

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
    print(data.username);
    notifyListeners();
  }

  Future<FirebaseUser> checkUserStatus() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user?.email != null) {
      print(user?.email);
      return user;
    } else {
      return null;
    }
  }

  Future<AuthenticationResult> signIn(
      {String email, String password, String type}) async {
    userType = type;

    // User Login
    FirebaseUser loginResult;
    try {
      loginResult = await firebaseLogin(email, password);
    } catch (e) {
      return AuthenticationResult(message: '${e.message}', result: false);
    }

    if (loginResult.runtimeType != PlatformException) {
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
    UserData userDataResult =
        await getDbData(userType: userType, uid: user.uid);
    userData = userDataResult;
    if (userDataResult != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if ((prefs.getBool(IS_LOGGED_IN) ?? false) != true) {
        prefs.setBool(IS_LOGGED_IN, true);
        prefs.setString(USER_TYPE, userType);
      }
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

  Future<AuthenticationResult> autoSignIn() async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser == null) {
      return AuthenticationResult(message: 'User not Logged in', result: false);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentUserType = prefs.getString(USER_TYPE);
      user = currentUser;
      userType = currentUserType;
      // Check Email Verification
      if (await isEmailVerified() == false) {
        return AuthenticationResult(
            message: 'Please Verify Your Email', result: false);
      }
      UserData userDataResult =
          await getDbData(userType: userType, uid: user.uid);
      userData = userDataResult;
      if (userDataResult != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if ((prefs.getBool(IS_LOGGED_IN) ?? false) != true) {
          prefs.setBool(IS_LOGGED_IN, true);
        }
        return AuthenticationResult(
          message:
              'Login Successful => ${userData.email} (${userData.userType})',
          result: true,
          userData: _userData,
        );
      } else {
        await firebaseSignOut();
        return AuthenticationResult(
            message: 'Login Failed! Please Try Again', result: false);
      }
    }
  }

  Future<AuthenticationResult> signUp({
    String email,
    String password,
    String username,
    String type,
    String dateOfBirth,
    double height,
    String gender,
    double weight,
  }) async {
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
      email: email,
      uid: user.uid,
      userType: userType,
      username: username,
      dateOfBirth: dateOfBirth,
      height: height,
      weight: weight,
      gender: gender,
    );
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
    if (user != null) {
      user = null;
    }
    if (userType != null) {
      userType = null;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_LOGGED_IN, false);
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
  Future<bool> addUserInDb({
    String email,
    String uid,
    String username,
    String userType,
    String dateOfBirth,
    double height,
    double weight,
    String gender,
  }) async {
    try {
      await _firestore.collection('$userType').document('$uid').setData({
        'email': email,
        'uid': uid,
        'username': username,
        'userType': userType,
        'DOB': dateOfBirth,
        'gender': gender,
        'weight': weight,
        'height': height,
      });
      return true;
    } catch (err) {
      print("ERROR");
      print(err);
      return false;
    }
  }

  Future<UserData> getDbData({String userType, String uid}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('$userType').document('$uid').get();
    if (snapshot.exists) {
      final data = snapshot.data;
      UserData uData = UserData.fromJson(data);
      userData = uData;
      print('PROVIDER => ' + _userData.username);
      return userData;
    } else {
      return null;
    }
  }
}
