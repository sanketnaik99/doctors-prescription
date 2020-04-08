import 'package:camera/camera.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:doctors_prescription/router.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  FluroRouter.setupRouter();
  final currentUser = await FirebaseAuth.instance.currentUser();
  print('***CURRENT USER*** : ${currentUser.uid}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
        ChangeNotifierProvider<PatientBloc>.value(value: PatientBloc()),
        ChangeNotifierProvider<DoctorBloc>.value(value: DoctorBloc())
      ],
      child: MaterialApp(
        title: 'Doctor\'s Prescription',
        initialRoute: 'login',
        onGenerateRoute: FluroRouter.router.generator,
      ),
    );
  }
}
