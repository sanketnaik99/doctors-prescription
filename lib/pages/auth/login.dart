import 'package:doctors_prescription/components/doctorPatientCard.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  String status = "Doctor";
  String email;
  String password;
  bool _loading = false;
  bool _hasOpenedPage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();

  pageOpened() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _hasOpenedPage = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pageOpened();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                color: _hasOpenedPage
                    ? Colors.green
                    : Colors.green.withOpacity(0.0),
                width:
                    _hasOpenedPage ? MediaQuery.of(context).size.width : 200.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                      child: Hero(
                        tag: 'prescription',
                        child: Image.asset(
                          'assets/icons/note.png',
                          height: 128.0,
                          width: 128.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 15.0, 0.0, 0.0),
                      child: Text(
                        'Sign In.',
                        style: GoogleFonts.poppins(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = USER_TYPE_DOCTOR;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/doctor.png',
                      title: 'Doctor',
                      elevation: status == USER_TYPE_DOCTOR ? 5.0 : 2.0,
                      backgroundColor: status == USER_TYPE_DOCTOR
                          ? Colors.green
                          : Colors.white,
                      textColor: status == USER_TYPE_DOCTOR
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = USER_TYPE_PATIENT;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/patient.png',
                      title: 'Patient',
                      elevation: status == USER_TYPE_PATIENT ? 5.0 : 2.0,
                      backgroundColor: status == USER_TYPE_PATIENT
                          ? Colors.green
                          : Colors.white,
                      textColor: status == USER_TYPE_PATIENT
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        onChanged: (String val) {
                          setState(() {
                            email = val;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _userEmailFocus,
                        onFieldSubmitted: (term) {
                          _userEmailFocus.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_userPasswordFocus);
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        // ignore: missing_return
                        validator: (String value) {
                          Pattern pattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regex = new RegExp(pattern);
                          print(value);
                          if (value.isEmpty) {
                            print('Please enter password');
                          } else {
                            if (!regex.hasMatch(value))
                              print('Enter valid password');
                            else
                              return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (val) => password = val,
                        textInputAction: TextInputAction.done,
                        focusNode: _userPasswordFocus,
                        onFieldSubmitted: (term) {
                          _userPasswordFocus.unfocus();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35.0),
              _loading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            height: 40.0,
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () async {
                                print("Login clicked");

                                setState(() {
                                  _loading = true;
                                });
                                //print(validateEmail(email));
                                // Dismiss Keyboard
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                final result = EmailValidator.validate(email);
                                print(_formKey.currentState.validate());
                                if (result == false) {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Email is Invalid!'),
                                    ),
                                  );
                                  setState(() {
                                    _loading = false;
                                  });
                                } else {
                                  AuthenticationResult result =
                                      await authBloc.signIn(
                                          email: email,
                                          password: password,
                                          type: status);
                                  if (result.result == true) {
                                    //Login Successful
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('${result.message}'),
                                      ),
                                    );
                                    setState(() {
                                      _loading = false;
                                    });
                                    if (authBloc.userData.userType ==
                                        'Doctor') {
                                      Provider.of<DoctorBloc>(context,
                                              listen: false)
                                          .currentDoctor = authBloc.userData;
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              DOCTOR_DASHBOARD);
                                    } else if (authBloc.userData.userType ==
                                        'Patient') {
                                      Provider.of<PatientBloc>(context,
                                              listen: false)
                                          .currentPatient = authBloc.userData;
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              PATIENT_DASHBOARD);
                                    }
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('${result.message}'),
                                      ),
                                    );
                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                }
                              },
                              color: Colors.green,
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                            height: 40.0,
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(REGISTER);
                              },
                              color: Colors.transparent,
                              child: Text(
                                'No account yet? Create one',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Login Page Validation

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Emaill';
    else
      return null;
  }
}
