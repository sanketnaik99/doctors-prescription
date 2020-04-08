import 'package:flutter/material.dart';

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
          )
        ],
      ),
    );
  }
}
