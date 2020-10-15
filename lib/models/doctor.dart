import 'package:flutter/cupertino.dart';

class QRScanResult {
  final String qrResult;

  QRScanResult({this.qrResult});
}

class PatientItem {
  final String email;
  final String uid;
  final String username;
  final String userType;
  final String gender;
  final String dobString;
  final DateTime dateOfBirth;

  PatientItem({
    @required this.email,
    @required this.userType,
    @required this.uid,
    @required this.username,
    this.gender,
    this.dobString,
    this.dateOfBirth,
  });

  factory PatientItem.fromJson(Map<String, dynamic> json) {
    return PatientItem(
      email: json['email'],
      username: json['username'],
      userType: json['userType'],
      uid: json['uid'],
      dobString: json['DOB'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(int.parse(json['DOB'])),
      gender: json['gender'],
    );
  }
}
