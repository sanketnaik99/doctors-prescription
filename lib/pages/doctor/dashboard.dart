import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/doctor.dart';
import 'package:doctors_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctors_prescription/pages/doctor/components/dashboard/patient_card.dart';
import 'package:doctors_prescription/pages/doctor/components/dashboard/profile_card.dart';
import 'package:doctors_prescription/pages/doctor/components/drawer.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    final DoctorBloc doctorBloc = Provider.of<DoctorBloc>(context);
    CollectionReference doctorCollectionReference =
        Firestore.instance.collection('Doctor');
    return Scaffold(
      appBar: DoctorAppBar(title: 'Dashboard'),
      drawer: DoctorAppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(DOCTOR_SCAN_QR);
        },
        heroTag: 'addPatient',
        tooltip: 'Add a Patient',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Your Profile',
                style: kDashboardTitleTextStyle,
              ),
            ),
            DoctorProfileCard(
              email: authBloc.userData?.email,
              name: authBloc.userData?.username,
              gender: authBloc.userData?.gender,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Patients',
                style: kDashboardTitleTextStyle,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: doctorCollectionReference
                    .document(authBloc.userData.uid)
                    .collection('Patients')
                    .getDocuments(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError ||
                      (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data.documents.length == 0)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/patient.png',
                              width: 128.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'No Patients Found.',
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
                              'Looks like you don\'t have any patients. Click the add button to add more patients.',
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
                  if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        PatientItem patientItem = PatientItem.fromJson(
                            snapshot.data.documents[index].data);
                        String age = Age.dateDifference(
                                fromDate: patientItem.dateOfBirth,
                                toDate: DateTime.now())
                            .years
                            .toString();
                        return PatientItemCard(
                          email: patientItem.email,
                          age: '$age Years',
                          gender: patientItem.gender,
                          name: patientItem.username,
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
