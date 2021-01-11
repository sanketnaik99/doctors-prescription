import 'package:doctors_prescription/components/detail_row.dart';
import 'package:flutter/material.dart';

class DoctorProfileCard extends StatelessWidget {
  final String email;
  final String name;
  final String gender;

  DoctorProfileCard({this.email, this.name, this.gender});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/doctor.png',
                    width: 80.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          title: 'Name',
                          data: this.name,
                        ),
                      ),
                      Expanded(
                        child: DetailRow(
                          title: 'Gender',
                          data: this.gender,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DetailRow(
                        title: 'Email',
                        data: this.email,
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
