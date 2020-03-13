import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/models.dart';
import 'package:flutter_practice/providers/auth_bloc.dart';
import 'package:provider/provider.dart';

// Register Page starts from here
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String status;
  String username, email, password, confirmPassword;
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
              child: Text('Register Here',
                  style:
                      TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20.0),
            Container(
              child: ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    color: status == "Doctor" ? Colors.green : Colors.grey,
                    child: Text(
                      "DOCTOR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        status = "Doctor";
                        print(status);
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "PATIENT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    color: status == "Patient" ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(() {
                        status = 'Patient';
                        print(status);
                      });
                    },
                  )
                ],
                alignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'USERNAME',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
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
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
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
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'CONFIRM PASSWORD',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                    ),
                    SizedBox(height: 40.0),
                    _loading
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Container(
                              child: Center(
                                child: LinearProgressIndicator(),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  // Dismiss Keyboard
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  if (password != confirmPassword) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Passwords do not match.'),
                                      ),
                                    );
                                    setState(() {
                                      _loading = false;
                                    });
                                  } else {
                                    AuthenticationResult result =
                                        await authBloc.signUp(
                                            email: email,
                                            password: password,
                                            username: username,
                                            type: status);
                                    if (result.result == true) {
                                      _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text('${result.message}'),
                                        ),
                                      );
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.pushReplacementNamed(
                                            context, 'login');
                                      });
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
                                child: Center(
                                  child: Text(
                                    'REGISTER',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
