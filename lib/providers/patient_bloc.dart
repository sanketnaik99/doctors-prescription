import 'dart:convert';
import 'dart:io';

import 'package:doctors_prescription/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String API_URL =
    'https://handwriting-recognition-api.herokuapp.com/api/v1';

class PatientBloc extends ChangeNotifier {
  final StorageReference _storageReference = FirebaseStorage().ref();
  bool _isUploading = false;
  bool _isProcessing = false;
  //String _imageURL =
  //    'https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/captures%2Ftest?alt=media&token=be7130dc-caa7-4033-ab4a-c1d160862633';
  String _imageURL = '';
  String _resultCode;
  String _resultMessage;
  List<String> _predictions = [];
  UserData _currentPatient;

  // Upload status getter
  bool get isUploading => _isUploading;

  // Upload Status Setter
  set isUploading(bool val) {
    _isUploading = val;
    notifyListeners();
  }

  // Processing status getter
  bool get isProcessing => _isProcessing;

  // Processing status setter
  set isProcessing(bool val) {
    _isProcessing = val;
    notifyListeners();
  }

  // Image URL Setter
  String get imageURL => _imageURL;

  // Image URL Getter
  set imageURL(String val) {
    _imageURL = val;
    notifyListeners();
  }

  String get resultCode => _resultCode;

  set resultCode(String val) {
    _resultCode = val;
    notifyListeners();
  }

  String get resultMessage => _resultMessage;

  set resultMessage(String val) {
    _resultMessage = val;
    notifyListeners();
  }

  List<String> get predictions => _predictions;

  set predictions(List<String> val) {
    _predictions = val;
    notifyListeners();
  }

  UserData get currentPatient => _currentPatient;

  set currentPatient(UserData val) {
    _currentPatient = val;
    notifyListeners();
  }

  Future<void> scanPrescription(String imagePath) async {
    isUploading = true;

    final String name = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'captures/test_app';

    final StorageUploadTask uploadTask =
        _storageReference.child(path).putFile(File(imagePath));

    await uploadTask.onComplete.then((snapshot) async {
      final downloadURL = await snapshot.ref.getDownloadURL();
      print(downloadURL);
      imageURL = downloadURL;
    });
    isUploading = false;
    isProcessing = true;

    final url = '$API_URL/predict-medicine';
    var response = await http.post(url, body: {'imageURL': imageURL});

    if (response.statusCode == 500) {
      final result = jsonDecode(response.body);
      resultCode = result['result'];
      resultMessage = result['message'];
      isProcessing = false;
    } else if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      resultCode = result['result'];
      resultMessage = result['message'];
      print(result['prediction']);
      predictions = result['prediction'].toString().split(" ");
      isProcessing = false;
    }
  }
}
