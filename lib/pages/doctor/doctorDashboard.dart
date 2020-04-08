import 'package:doctors_prescription/components/doctorAppBar.dart';
import 'package:doctors_prescription/components/doctorDrawer.dart';
import 'package:doctors_prescription/components/itemCard.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  Widget build(BuildContext context) {
    final DoctorBloc doctorBloc = Provider.of<DoctorBloc>(context);
    return Scaffold(
      appBar: DoctorAppBar(title: 'Dashboard'),
      drawer: DoctorAppDrawer(),
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
              avatarImage: AssetImage('assets/icons/doctor.png'),
              title: '${doctorBloc.currentDoctor.username}',
              content: [
                'EMAIL: ${doctorBloc.currentDoctor.email}',
                'UID: ${doctorBloc.currentDoctor.uid}'
              ],
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
