import 'package:doctors_prescription/components/userDetailRow.dart';
import 'package:flutter/material.dart';

class DoctorProfileCard extends StatelessWidget {
  final String email;
  final String name;
  final String gender;

  DoctorProfileCard({this.email, this.name, this.gender});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/icons/doctor.png',
                  width: 80.0,
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      UserDetailRow(
                        iconPath: 'assets/icons/name.png',
                        title: this.name,
                      ),
                      UserDetailRow(
                        iconPath: 'assets/icons/sex.png',
                        title: this.gender,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserDetailRow(
                        iconPath: 'assets/icons/email.png',
                        title: this.email,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
