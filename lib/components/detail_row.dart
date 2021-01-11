import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String data;
  final String title;

  DetailRow({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$data',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
