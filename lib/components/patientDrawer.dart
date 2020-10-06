import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('patientDashboard');
            },
            child: ListTile(
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('prescriptionScan');
            },
            child: ListTile(
              title: Text(
                "Scan Prescription",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('qrCode');
            },
            child: ListTile(
              title: Text(
                "Show QR",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Provider.of<AuthBloc>(context, listen: false)
                  .firebaseSignOut();
              Navigator.of(context).pushReplacementNamed(LOGIN);
            },
            child: ListTile(
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
