import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueAccent,
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Image.asset(
                    'assets/icons/note.png',
                    width: 120.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Doctor\'s Prescription',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0)
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
              },
              title: Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(DOCTOR_SCAN_QR);
              },
              title: Text(
                "Add Patient",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                await Provider.of<AuthBloc>(context, listen: false)
                    .firebaseSignOut();
                Navigator.of(context).pushReplacementNamed(LOGIN);
              },
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
