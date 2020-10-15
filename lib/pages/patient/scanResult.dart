import 'dart:convert';

import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/patient/components/app_bar.dart';
import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/patient/components/drawer.dart';

class ScanResult extends StatefulWidget {
  ScanResult();

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  static final _base64SafeEncoder = const Base64Codec.urlSafe();

  @override
  void initState() {
    super.initState();
    //final imagePath = utf8.decode(_base64SafeEncoder.decode(widget.imagePath));
    //print(imagePath);
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
        body: patientBloc.isUploading
            ? Center(
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
              )
            : patientBloc.isProcessing
                ? Center(
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
                  )
                : patientBloc.medicines.length > 0
                    ? ListView.builder(
                        itemCount: patientBloc.medicines.length,
                        itemBuilder: (context, index) {
                          print(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 5.0),
                              color: Colors.green[200],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    Center(
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            patientBloc.medicines[index].image),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              patientBloc.medicines[index].name,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              patientBloc
                                                  .medicines[index].category,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              patientBloc
                                                  .medicines[index].weight,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/icons/close.png'),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'There was an error while processing the image.',
                                style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ));
  }
}
