import 'package:flutter/material.dart';

class UserDetailRow extends StatelessWidget {
  final String title;
  final String iconPath;

  UserDetailRow({this.title, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 40.0,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          '$title',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
