import 'package:doctors_prescription/components/itemCard.dart';
import 'package:doctors_prescription/components/patientAppBar.dart';
import 'package:doctors_prescription/components/patientDrawer.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      appBar: PatientAppBar(title: 'Dashboard'),
      drawer: PatientDrawer(),
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
            ItemCard(
              backgroundColor: Colors.lightBlue.shade100,
              avatarImage: AssetImage('assets/icons/patient.png'),
              title: '${patientBloc.currentPatient.username}',
              content: [
                'EMAIL: ${patientBloc.currentPatient.email}',
                'UID: ${patientBloc.currentPatient.uid}'
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Prescriptions',
                style: kDashboardTitleTextStyle,
              ),
            ),
            ItemCard(
              avatarImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/Medicines%2FBENADRYL?alt=media&token=2161cc44-e700-479e-8424-669b1251ec07'),
              backgroundColor: Colors.green[200],
              title: 'Benadryl DR Syrup 100ml',
              content: ['Dosage: 100ml', 'Category: Cough and Cold'],
            ),
            ItemCard(
              avatarImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/Medicines%2FCROCIN?alt=media&token=b373b505-b015-420c-ba28-d59e6398a1a9'),
              backgroundColor: Colors.green[200],
              title: 'Crocin 650mg Tablet',
              content: ['Dosage: 650mg', 'Category: Fever'],
            )
          ],
        ),
      ),
    );
  }
}
