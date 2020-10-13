import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/components/doctor/app_bar.dart';
import 'package:doctors_prescription/components/doctor/drawer.dart';
import 'package:doctors_prescription/components/patient/add_patient/detail_profile_card.dart';
import 'package:doctors_prescription/models/doctor.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResultPage extends StatefulWidget {
  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.black;

  addPatient(UserData patient, FirebaseUser doctor) async {
    setState(() {
      _isLoading = true;
    });
    bool result = await Provider.of<DoctorBloc>(context, listen: false)
        .addNewPatient(patient, doctor);

    if (result == true) {
      setState(() {
        _isLoading = false;
        _message = 'Patient Added Successfully';
        _messageColor = Colors.green;
      });
      Provider.of<DoctorBloc>(context, listen: false).fetchPatients();
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
      });
    } else {
      setState(() {
        _isLoading = false;
        _message = 'An Error Occurred. Please Try Again';
        _messageColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch patient and display result.
    final QRScanResult args = ModalRoute.of(context).settings.arguments;
    DoctorBloc doctorBloc = Provider.of<DoctorBloc>(context);
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    CollectionReference patient = Firestore.instance.collection('Patient');
    return Scaffold(
      appBar: DoctorAppBar(
        title: 'Scan Result',
      ),
      drawer: DoctorAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: patient.document(args.qrResult).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError ||
                      (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data.data == null)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/database.png',
                              width: 200.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Something went wrong.',
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Please make sure that the patient has registered and you are connected to the internet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data.exists) {
                    Map<String, dynamic> data = snapshot.data.data;
                    UserData patient = UserData.fromJson(data);
                    int ageInYears = Age.dateDifference(
                            fromDate: patient.dateOfBirth,
                            toDate: DateTime.now())
                        .years;
                    return Column(
                      children: [
                        PatientDetailProfileCard(
                          email: patient.email,
                          name: patient.username,
                          gender: patient.gender,
                          height: '${patient.height.toString()} cm',
                          weight: '${patient.weight.toString()} Kg',
                          age: '$ageInYears Years',
                        ),
                        SizedBox(height: 25.0),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : RaisedButton.icon(
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                onPressed: () {
                                  addPatient(patient, authBloc.user);
                                },
                                icon: Icon(Icons.add),
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 15.0),
                                  child: Text(
                                    'Add as Patient',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _message == ''
                            ? SizedBox()
                            : Text(
                                '$_message',
                                style: TextStyle(
                                  color: _messageColor,
                                  fontSize: 14.0,
                                ),
                              )
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
