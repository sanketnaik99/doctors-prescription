import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorBloc extends ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  UserData _currentDoctor;
  UserData _newPatient;
  bool _isLoadingPatientData = false;
  bool _hasNewPatientData = false;
  List _patients;
  bool _isLoadingPatients = false;
  bool _hasPatients = false;

  UserData get currentDoctor => _currentDoctor;

  set currentDoctor(UserData val) {
    _currentDoctor = val;
    notifyListeners();
  }

  get isLoadingPatientData => _isLoadingPatientData;

  set isLoadingPatientData(bool val) {
    _isLoadingPatientData = val;
    notifyListeners();
  }

  get hasNewPatientData => _hasNewPatientData;

  set hasNewPatientData(bool val) {
    _hasNewPatientData = val;
    notifyListeners();
  }

  // Get new Patient Data
  UserData get newPatient => _newPatient;

  // Set new Patient Data
  set newPatient(UserData val) {
    _newPatient = val;
    notifyListeners();
  }

  List get patients => _patients;

  set patients(List val) {
    _patients = val;
    notifyListeners();
  }

  get hasPatients => _hasPatients;

  set hasPatients(bool val) {
    _hasPatients = val;
    notifyListeners();
  }

  get isLoadingPatients => _isLoadingPatients;

  set isLoadingPatients(bool val) {
    _isLoadingPatients = val;
    notifyListeners();
  }

  Future<bool> fetchNewPatientData(String uid) async {
    try {
      isLoadingPatientData = true;
      final patientRef = _firestore.collection('Patient').document(uid);
      final dataSnapshot = await patientRef.get();
      if (dataSnapshot.exists) {
        final data = dataSnapshot.data;
        newPatient = UserData(
          email: data['email'],
          username: data['username'],
          uid: data['uid'],
          userType: data['userType'],
        );
        print(newPatient);
        isLoadingPatientData = false;
        hasNewPatientData = true;
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> addNewPatient(UserData patient, FirebaseUser doctor) async {
    try {
      print("***CURRENT PATIENT*** ${patient.email}");
      final newPatientRef = _firestore
          .collection('Doctor')
          .document(doctor.uid)
          .collection('Patients')
          .document(patient.uid);
      await newPatientRef.setData({
        'username': patient.username,
        'email': patient.email,
        'uid': patient.uid,
        'DOB': patient.dobString,
        'userType': patient.userType,
        'gender': patient.gender,
      });
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> fetchPatients() async {
    isLoadingPatients = true;
    try {
      final patientsRef = _firestore
          .collection('Doctor')
          .document(currentDoctor.uid)
          .collection('Patients');
      final dataSnapshot = await patientsRef.getDocuments();
      if (dataSnapshot.documents.length != 0) {
        final data = dataSnapshot.documents.map((doc) => doc.data).toList();
        isLoadingPatients = false;
        patients = data;
        hasPatients = true;
      } else {
        hasPatients = false;
        isLoadingPatients = false;
        print("NO PATIENT");
      }
    } catch (err) {
      print(err);
      isLoadingPatients = false;
    }
  }
}
