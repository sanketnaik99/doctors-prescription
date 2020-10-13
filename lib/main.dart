import 'package:camera/camera.dart';
import 'package:doctors_prescription/pages/auth/login.dart';
import 'package:doctors_prescription/pages/auth/registration.dart';
import 'package:doctors_prescription/pages/doctor/add_patient.dart';
import 'package:doctors_prescription/pages/doctor/add_patient/scan_qr.dart';
import 'package:doctors_prescription/pages/doctor/add_patient/scan_result.dart';
import 'package:doctors_prescription/pages/doctor/dashboard.dart';
import 'package:doctors_prescription/pages/patient/patientDashboard.dart';
import 'package:doctors_prescription/pages/patient/prescriptionScan.dart';
import 'package:doctors_prescription/pages/patient/scanResult.dart';
import 'package:doctors_prescription/pages/patient/showQR.dart';
import 'package:doctors_prescription/pages/splash.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        ChangeNotifierProvider<PatientBloc>(
          create: (_) => PatientBloc(),
        ),
        ChangeNotifierProvider<DoctorBloc>(
          create: (_) => DoctorBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Doctor\'s Prescription',
        initialRoute: SPLASH,
        theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        routes: {
          SPLASH: (context) => SplashScreenPage(),
          LOGIN: (context) => LoginPage(),
          REGISTER: (context) => Registration(),

          // DOCTOR ROUTES
          DOCTOR_DASHBOARD: (context) => DoctorDashboard(),
          DOCTOR_ADD_PATIENT: (context) => AddPatientPage(),
          DOCTOR_SCAN_QR: (context) => ScanQRPage(),
          DOCTOR_SCAN_RESULT: (context) => ScanResultPage(),

          PATIENT_DASHBOARD: (context) => PatientDashboard(),
          PATIENT_PRESCRIPTION_SCAN: (context) => PrescriptionScan(),
          PATIENT_SCAN_RESULT: (context) => ScanResult(),
          PATIENT_SHOW_QR: (context) => QrCodePage(),
        },
      ),
    );
  }
}
