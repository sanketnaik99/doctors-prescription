import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:doctors_prescription/components/patientAppBar.dart';
import 'package:doctors_prescription/components/patientDrawer.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:provider/provider.dart';

class ScanResult extends StatefulWidget {
  final String imagePath;

  ScanResult({@required this.imagePath});

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  static final _base64SafeEncoder = const Base64Codec.urlSafe();

  @override
  void initState() {
    super.initState();
    final imagePath = utf8.decode(_base64SafeEncoder.decode(widget.imagePath));
    print(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PatientAppBar(
        title: 'Scan Result',
      ),
      drawer: PatientDrawer(),
      body: Column(
        children: <Widget>[
          patientBloc.isUploading
              ? Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300.0,
                      child: FlareActor(
                        'assets/animations/uploading.flr',
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,
                        animation: 'uploading',
                      ),
                    ),
                  ),
                )
              : patientBloc.isProcessing
                  ? Expanded(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300.0,
                          child: FlareActor(
                            'assets/animations/processing.flr',
                            alignment: Alignment.topCenter,
                            fit: BoxFit.contain,
                            animation: 'process',
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Text(
                          'Result : ${patientBloc.resultCode}',
                        ),
                        Text(
                          'Message : ${patientBloc.resultMessage}',
                        ),
                        Text(
                          'Predictions = ${patientBloc.predictions.toString()}',
                        )
                      ],
                    )
//          Image.file(
//            File(widget.imagePath),
//          ),
        ],
      ),
    );
  }
}
