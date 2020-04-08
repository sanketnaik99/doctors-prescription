import 'package:flutter/material.dart';

class DoctorAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('doctorDashboard');
            },
            child: ListTile(
              title: Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('qrScanner');
            },
            child: ListTile(
              title: Text(
                "Add Patient",
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
