import 'package:doctors_prescription/components/userDetailRow.dart';
import 'package:flutter/material.dart';

class PatientDetailProfileCard extends StatelessWidget {
  final String email;
  final String name;
  final String gender;
  final String height;
  final String weight;
  final String age;

  PatientDetailProfileCard(
      {this.email, this.name, this.gender, this.height, this.weight, this.age});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Image.asset(
                    'assets/icons/patient.png',
                    width: 80.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserDetailRow(
                        title: 'Name',
                        data: this.name,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      UserDetailRow(
                        title: 'Email',
                        data: this.email,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Table(
                border: TableBorder.all(
                  width: 0.0,
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    children: [
                      UserDetailRow(
                        title: 'Age',
                        data: this.age,
                      ),
                      UserDetailRow(
                        title: 'Gender',
                        data: this.gender,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      UserDetailRow(
                        title: 'Height',
                        data: this.height,
                      ),
                      UserDetailRow(
                        title: 'Weight',
                        data: this.weight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
