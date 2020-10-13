import 'package:doctors_prescription/components/doctor/dashboard/profile_card.dart';
import 'package:doctors_prescription/components/itemCard.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/components/doctor/app_bar.dart';
import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/components/doctor/drawer.dart';

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
            doctorBloc.isLoadingPatients
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  )
                : doctorBloc.hasPatients
                    ? Column(
                        children: <Widget>[
                          for (var patient in doctorBloc.patients)
                            ItemCard(
                              backgroundColor: Colors.green.shade200,
                              avatarImage:
                                  AssetImage('assets/icons/patient.png'),
                              title: '${patient['username']}',
                              content: [
                                'EMAIL: ${patient['email']}',
                              ],
                            ),
                        ],
                      )
                    : Text(
                        "Looks like you have no patients.",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
