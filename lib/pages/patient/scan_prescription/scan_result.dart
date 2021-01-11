import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/medicine.dart';
import 'package:doctors_prescription/models/patient.dart';
import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:doctors_prescription/pages/patient/scan_prescription/add_medicine.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:string_similarity/string_similarity.dart';

class PatientScanResult extends StatefulWidget {
  @override
  _PatientScanResultState createState() => _PatientScanResultState();
}

class _PatientScanResultState extends State<PatientScanResult> {
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.white;
  String _imagePath = '';
  String _imagePath2 = '';

  static const platform =
      const MethodChannel('com.example.flutter_doctorsprescription/pipeline');

  predictMedicine(String imagePath) async {
    Dio dio = new Dio();
    setState(() {
      _isLoading = true;
    });
    FormData formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(imagePath, filename: 'image.txt'),
      },
    );
    Response response;
    try {
      response = await dio.post(
        'https://handwriting-recognition-api.herokuapp.com/api/v1/predict-medicine',
        data: formData,
      );
      if (response.statusCode == 200) {
        var result = response.data;
        print(result.toString());
        print(result['result']);
        print(result['prediction']);
        setState(() {
          _isLoading = false;
          _message = 'SUCCESS!\n${result['prediction']}';
          _messageColor = Colors.green;
        });
      } else {
        // TODO: ERROR HANDLING
        setState(() {
          _isLoading = false;
          _message = 'ERROR! Please Try Again.';
          _messageColor = Colors.red;
        });
      }
    } on DioError catch (err) {
      print(err.response);
      setState(() {
        _isLoading = false;
        _message = 'ERROR! Please Try Again.';
        _messageColor = Colors.red;
      });
    }
  }

  dpPipeline(String imagePath) async {
    setState(() {
      _isLoading = true;
    });
    print(imagePath);
    try {
      var result =
          await platform.invokeMethod('pipeline', {"imagePath": imagePath});
      print("RESULT $result");
      final box = Hive.box(MEDICINES_BOX);
      var values = box.keys;
      List<String> preds = result[1].toString().split(' ');
      List<String> valuesString = List<String>.from(values);
      List<Medicine> predictions = [];
      preds.forEach((prediction) {
        var matches = prediction.bestMatch(valuesString);
        print(matches.bestMatch.toString());
        if (matches.bestMatch.rating > 0.6) {
          String match = matches.bestMatch.target;
          Medicine matchedMedicine = Medicine.fromJson(box.get(match));
          predictions.add(matchedMedicine);
        }
      });
      if (predictions.length > 0) {
        setState(() {
          _isLoading = false;
          _imagePath = result[0];
          _message = 'SUCCESS!';
          _messageColor = Colors.green;
        });
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushNamed(
            PATIENT_ADD_MEDICINE,
            arguments: AddMedicineArguments(medicines: predictions),
          );
        });
      } else {
        setState(() {
          _isLoading = false;
          _imagePath = imagePath;
          _message = 'ERROR! No Matches Found.\nPlease try again';
          _messageColor = Colors.red;
        });
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
        _imagePath = imagePath;
        _message = 'ERROR! No Matches Found.\nPlease try again';
        _messageColor = Colors.red;
      });
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final PatientScanImageResult result =
          ModalRoute.of(context).settings.arguments;
      setState(() {
        _imagePath = result.imagePath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: 'Scan Result'),
      body: Column(
        children: [
          Container(
            height: 100.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Confirm that the image is sharp and the prescription is visible.',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Image.file(
            File(_imagePath),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      PATIENT_SCAN_PRESCRIPTION);
                                },
                                padding: const EdgeInsets.all(30.0),
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 25.0,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                                label: Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                ),
                                splashColor: Colors.grey.shade200,
                              ),
                              FlatButton(
                                onPressed: () {
                                  // predictMedicine(_imagePath);
                                  dpPipeline(_imagePath);
                                },
                                padding: const EdgeInsets.all(30.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.75),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 25.0,
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                  ],
                                ),
                                splashColor: Colors.grey.shade200,
                              )
                            ],
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _message == ''
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              '$_message',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: _messageColor,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
