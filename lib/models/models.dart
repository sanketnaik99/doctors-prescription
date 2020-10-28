import 'package:flutter/cupertino.dart';

class AuthenticationResult {
  final String message;
  final bool result;
  final UserData userData;

  AuthenticationResult({this.message, this.result, this.userData});
}

class UserData {
  final String email;
  final String uid;
  final String userType;
  final String username;
  final String gender;
  final String dobString;
  final DateTime dateOfBirth;
  final double height;
  final double weight;
  final patients;

  UserData({
    @required this.email,
    @required this.userType,
    @required this.uid,
    @required this.username,
    this.dobString,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.height,
    this.patients,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      username: json['username'],
      userType: json['userType'],
      uid: json['uid'],
      patients: json['patients'],
      dobString: json['DOB'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(int.parse(json['DOB'])),
      weight: json['weight'],
      gender: json['gender'],
      height: json['height'],
    );
  }
}

// class Medicine {
//   final String category;
//   final String id;
//   final String image;
//   final String name;
//   final String weight;
//
//   Medicine(
//       {@required this.category,
//       @required this.id,
//       @required this.image,
//       @required this.name,
//       @required this.weight});
// }
