import 'dart:io';

import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  CameraPreviewWidget({this.imagePath, this.retry, this.upload});

  final String imagePath;
  final Function retry;
  final Function upload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(imagePath),
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          height: 80.0,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                onPressed: this.retry,
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colors.white,
                ),
                label: Text(
                  'Retry',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                splashColor: Colors.grey.shade700,
              ),
              FlatButton.icon(
                onPressed: this.upload,
                icon: Icon(
                  Icons.cloud_upload,
                  size: 25.0,
                  color: Colors.white,
                ),
                label: Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                splashColor: Colors.grey.shade700,
              )
            ],
          ),
        )
      ],
    );
  }
}
