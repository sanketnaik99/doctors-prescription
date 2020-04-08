import 'package:doctors_prescription/pages/doctor/doctorDashboard.dart';
import 'package:doctors_prescription/pages/patient/patientDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:doctors_prescription/pages/home.dart';
import 'package:doctors_prescription/pages/auth/login.dart';
import 'package:doctors_prescription/pages/patient/prescriptionScan.dart';
import 'package:doctors_prescription/pages/patient/scanResult.dart';
import 'package:doctors_prescription/pages/patient/showQR.dart';
import 'package:doctors_prescription/pages/doctor/scanQR.dart';
import 'package:doctors_prescription/pages/auth/registration.dart';

class FluroRouter {
  static Router router = Router();

  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());

  static Handler _registrationHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterPage());

  static Handler _HomeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());

  static Handler _QrCodeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          QrCodePage());

  static Handler _QrScannerHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          QrScannerPage());

  static Handler _prescriptionScanHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        PrescriptionScan(),
  );

  static Handler _scanResultHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ScanResult(imagePath: params['imagePath'][0]));

  static Handler _doctorDashboardHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        DoctorDashboard(),
  );

  static Handler _patientDashboardHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
        PatientDashboard(),
  );

  static void setupRouter() {
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'register',
      handler: _registrationHandler,
    );
    router.define(
      'home',
      handler: _HomeHandler,
    );
    router.define(
      'qrCode',
      handler: _QrCodeHandler,
    );
    router.define(
      'qrScanner',
      handler: _QrScannerHandler,
    );
    router.define(
      'prescriptionScan',
      handler: _prescriptionScanHandler,
    );
    router.define(
      'scanResult/:imagePath',
      handler: _scanResultHandler,
    );
    router.define(
      'doctorDashboard',
      handler: _doctorDashboardHandler,
    );
    router.define(
      'patientDashboard',
      handler: _patientDashboardHandler,
    );
  }
}
