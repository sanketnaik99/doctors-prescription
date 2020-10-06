import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  UserData _userData;
  bool _isLoggedIn = false;
  bool _showSplash = false;

  checkLogin() async {
    //Provider.of<AuthBloc>(context, listen: false).firebaseSignOut();
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getBool(IS_LOGGED_IN) ?? false) == true) {
      FirebaseUser user = await authBloc.checkUserStatus();
      if (user != null) {
        print("EMAIL = ${user.email}");

        String currentUserType = prefs.getString(USER_TYPE);
        UserData userData =
            await authBloc.getDbData(userType: currentUserType, uid: user.uid);
        setState(() {
          _userData = userData;
        });

        //authBloc.userData = userData;

        // USER LOGGED IN
        // IS A DOCTOR
        if (userData.userType == USER_TYPE_DOCTOR) {
          setState(() {
            _isLoggedIn = true;
          });

          // FETCH PATIENTS
          // Provider.of<DoctorBloc>(context, listen: false).fetchPatients();

          // NAVIGATE TO DOCTOR DASHBOARD
          Future.delayed(const Duration(seconds: 1), () {
            print(authBloc.userData.username);
            Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
          });
        }
        //
        // IS A PATIENT
        else if (userData.userType == USER_TYPE_PATIENT) {
          setState(() {
            _isLoggedIn = true;
          });

          // UPDATE PATIENT BLOC
          // Provider.of<PatientBloc>(context, listen: false).currentPatient =
          //     _userData;

          // NAVIGATE TO PATIENT DASHBOARD
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacementNamed(PATIENT_DASHBOARD);
          });
        }
      }
    } else {
      print('Not Logged In');
      Future.delayed(
          const Duration(
            milliseconds: 2000,
          ), () {
        Navigator.of(context).pushReplacementNamed(LOGIN);
      });
    }
  }

  showSplash() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showSplash = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showSplash();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'prescription',
                  child: AnimatedOpacity(
                    opacity: _showSplash ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/icons/note.png',
                      height: 256.0,
                      width: 256.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                AnimatedOpacity(
                  opacity: _showSplash ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Doctor\'s Prescription',
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _isLoggedIn ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 800),
                  child: Text(
                    'Welcome ${_userData?.username ?? ''}',
                    style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
