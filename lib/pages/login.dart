import 'package:flutter/material.dart';
import 'package:flutter_practice/services/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  Auth auth = Auth();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> signIn() async {
    final String user = await auth.signIn(email, password);
    if (user != null) {
      final bool isVerified = await auth.isEmailVerified();
      if (isVerified) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Login Successful => $user'),
          ),
        );
        return true;
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please verify your email!'),
          ),
        );
        return false;
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Login Failed!'),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          //helperText: 'Enter the valid Email',
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
                    SizedBox(height: 20.0),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
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
                      //validator: passwordValidator,
                    ),
                  ]),
                ),
                SizedBox(height: 20.0),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  child: GestureDetector(
                    onTap: () {
                      print("Login clicked");
                      //print(validateEmail(email));
                      // Dismiss Keyboard
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      signIn();
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          'Login',
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
                          'Register',
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
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value == null) {
      return "Enter the Password";
    }
    value == "hello" ? print('Hello') : print('Not Hello');
  }
}
