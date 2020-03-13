import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/models.dart';
import 'package:flutter_practice/providers/auth_bloc.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  String status;
  String email;
  String password;
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 0.0),
                  child: Text('Welcome',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 30.0, 0.0, 0.0),
                  child: Text('Sign in to Continue',
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
              ],
            ),
            Container(
              child: ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    color: status == "Doctor" ? Colors.green : Colors.grey,
                    onPressed: () {
                      print(status);
                      setState(() {
                        status = "Doctor";
                        print(status);
                      });
                    },
                    child: Text(
                      "DOCTOR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "PATIENT",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: status == "Patient" ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(() {
                        status = "Patient";
                        print(status);
                      });
                    },
                  )
                ],
                alignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                  onChanged: (String val) {
                    setState(() {
                      email = val;
                    });
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
                          borderSide: BorderSide(color: Colors.green))),

                  obscureText: true,
                  onChanged: (val) => password = val,
                ),
              ]),
            ),
            SizedBox(height: 20.0),
//            Container(
//              child: Center(
//                child: _loading ? LinearProgressIndicator() : Text(""),
//              ),
//            ),
//            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              height: 40.0,
              child: GestureDetector(
                onTap: () async {
                  print("Login clicked");

                  setState(() {
                    _loading = !_loading;
                  });
                  //print(validateEmail(email));
                  // Dismiss Keyboard
                  FocusScopeNode currentFocus = FocusScope.of(context);
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
                  } else {
                    AuthenticationResult result = await authBloc.signIn(
                        email: email, password: password, type: status);
                    if (result.result == true) {
                      //Login Successful
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('${result.message}'),
                        ),
                      );
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('${result.message}'),
                        ),
                      );
                    }
                  }
                  Navigator.pushNamed(context, 'home');
                },
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  elevation: 7.0,
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
              height: 40.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'register');
                },
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  //shadowColor: Colors.greenAccent,
                  //color: Colors.green,
                  elevation: 7.0,
                  child: Center(
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
