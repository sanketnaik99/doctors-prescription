import 'package:flutter/cupertino.dart';

class AuthenticationResult {
  final String message;
  final bool result;

  AuthenticationResult({this.message, this.result});
}

class UserData {
  final String email;
  final String uid;
  final String userType;
  final String username;
  final patients;

  UserData(
      {@required this.email,
      @required this.userType,
      @required this.uid,
      @required this.username,
      this.patients});
}
