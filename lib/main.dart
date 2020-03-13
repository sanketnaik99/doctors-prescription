import 'package:flutter/material.dart';
import 'package:flutter_practice/providers/auth_bloc.dart';
import 'package:flutter_practice/router.dart';
import 'package:provider/provider.dart';

void main() {
  FluroRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
      ],
      child: MaterialApp(
        title: 'Doctor\'s Prescription',
        initialRoute: 'login',
        onGenerateRoute: FluroRouter.router.generator,
      ),
    );
  }
}
