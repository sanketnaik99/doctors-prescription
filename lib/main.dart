import 'package:flutter/material.dart';
import 'package:flutter_practice/router.dart';

void main() {
  FluroRouter.setupRouter();
  runApp(MaterialApp(
    title: 'Doctor\'s Prescription',
    initialRoute: 'login',
    onGenerateRoute: FluroRouter.router.generator,
  ));
}
