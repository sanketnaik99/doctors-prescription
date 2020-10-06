import 'dart:io';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;

  Future getImage() async {
    setState(() {
      //_image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Prescription'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: const Text("Press button to open camera."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.green,
      ),
    );
  }
}
