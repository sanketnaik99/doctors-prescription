import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/medicine.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

const String API_URL =
    'https://handwriting-recognition-api.herokuapp.com/api/v1';

class PatientBloc extends ChangeNotifier {
  final StorageReference _storageReference = FirebaseStorage().ref();
  final _firestore = Firestore.instance;
  bool _isUploading = false;
  bool _isProcessing = false;
  bool _hasProcessingError = false;
  String _imageURL = '';
  String _resultCode;
  String _resultMessage;
  List<String> _predictions = [];
  UserData _currentPatient;
  List<Medicine> _medicines = [];

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

  // Processing status getter
  bool get hasProcessingError => _isProcessing;

  // Processing status setter
  set hasProcessingError(bool val) {
    _hasProcessingError = val;
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

  List<Medicine> get medicines => _medicines;

  set medicines(List<Medicine> val) {
    _medicines = val;
    notifyListeners();
  }

  UserData get currentPatient => _currentPatient;

  set currentPatient(UserData val) {
    _currentPatient = val;
    notifyListeners();
  }

  Future<void> updateMedicines() async {
    final medicinesRef = _firestore.collection('Medicines');
    final box = Hive.box(MEDICINES_BOX);
    medicinesRef.getDocuments().then((QuerySnapshot docs) {
      docs.documents.forEach((doc) {
        print(doc.documentID);
        box.put(doc.documentID, doc.data);
      });
    }).catchError((err) {
      print(err);
    });
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
      hasProcessingError = true;
      print('ERROR');
    } else if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      resultCode = result['result'];
      resultMessage = result['message'];
      print(result['prediction']);
      predictions = result['prediction'].toString().split(" ");
      print(predictions);
      predictions.forEach((element) async {
        QuerySnapshot snapshots = await _firestore
            .collection('Medicines')
            .where('id', isEqualTo: element)
            .getDocuments();
        final med = snapshots.documents[0].data;
        medicines = [
          ...medicines,
          Medicine(
              category: med['category'],
              id: med['id'],
              image: med['image'],
              name: med['name'],
              weight: med['weight'])
        ];
        print(medicines[0].name);
      });
      isProcessing = false;
    }
  }
}
