import 'package:age/age.dart';
import 'package:doctors_prescription/components/detail_row.dart';
import 'package:doctors_prescription/components/doctorPatientCard.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _hasOpenedPage = false;
  int _currentStep = 0;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // REGISTRATION FORM
  final _registrationFormKey = GlobalKey<FormState>();
  String _userEmail, _userPassword, _userConfirmPassword, _userType;
  bool _passwordVisible = false, _confirmPasswordVisible = false;
  bool _hasNotSelectedUserType = false;

  final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();
  final FocusNode _userConfirmPasswordFocus = FocusNode();

  // DETAILS FORM
  final _detailsFormKey = GlobalKey<FormState>();
  String _userName, _userGender, _userDOBText;
  DateTime _userDOB = DateTime.now();
  double _userHeight, _userWeight;
  TextEditingController _userDOBController = new TextEditingController();

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _userDOBFocus = FocusNode();
  final FocusNode _userGenderFocus = FocusNode();
  final FocusNode _userHeightFocus = FocusNode();
  final FocusNode _userWeightFocus = FocusNode();

  pageOpened() {
    Future.delayed(const Duration(milliseconds: 20), () {
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

  _onStepContinue() async {
    if (this._currentStep < this.registrationSteps().length) {
      switch (this._currentStep) {
        case 0:
          {
            if (_registrationFormKey.currentState.validate() &&
                _userType != null) {
              setState(() {
                this._currentStep = this._currentStep + 1;
              });
            }
            if (_userType == null) {
              _hasNotSelectedUserType = true;
            }
            break;
          }
        case 1:
          {
            print(_detailsFormKey.currentState.validate());
            if (_detailsFormKey.currentState.validate()) {
              setState(() {
                this._currentStep = this._currentStep + 1;
              });
            }
            break;
          }
        case 2:
          {
            setState(() {
              this._isLoading = true;
            });
            AuthenticationResult result =
                await Provider.of<AuthBloc>(context, listen: false).signUp(
              email: _userEmail,
              password: _userPassword,
              username: _userName,
              type: _userType,
              gender: _userGender,
              dateOfBirth: _userDOB.millisecondsSinceEpoch.toString(),
              weight: _userWeight,
              height: _userHeight,
            );
            if (result.result == true) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('${result.message}'),
                ),
              );
              setState(() {
                _isLoading = false;
              });
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pushReplacementNamed(LOGIN);
              });
            } else {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('${result.message}'),
                ),
              );
              setState(() {
                _isLoading = false;
              });
            }
            break;
          }
      }
    } else {
      print(this._currentStep);
      print('done');
      //DONE NAVIGATING THE LOGIC
    }
  }

  _onStepCancel() {
    switch (this._currentStep) {
      case 0:
        {
          setState(() {
            this._userEmail = null;
            this._userPassword = null;
            this._userConfirmPassword = null;
            this._hasNotSelectedUserType = false;
            this._userType = null;
          });
          _resetRegistrationForm();
          break;
        }
      case 1:
        {
          setState(() {
            this._userName = null;
            this._detailsFormKey.currentState.reset();
            this._userDOB = DateTime.now();
            this._userGender = null;
            this._userHeight = null;
            this._userWeight = null;
            this._userDOBController.value = TextEditingValue(text: '');
            this._currentStep = this._currentStep - 1;
          });
          break;
        }
      case 2:
        {
          setState(() {
            this._currentStep = this._currentStep - 1;
          });
          break;
        }
    }
  }

  _resetRegistrationForm() {
    print("Reset");
    setState(() {
      this._registrationFormKey.currentState.reset();
      this._registrationFormKey.currentState.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            color: _hasOpenedPage
                ? Colors.blueAccent
                : Colors.blueAccent.withOpacity(0.0),
            width: _hasOpenedPage ? MediaQuery.of(context).size.width : 200.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: Text(
                    'Register.',
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stepper(
                    steps: registrationSteps(),
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepContinue: _onStepContinue,
                    onStepCancel: _onStepCancel,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: onStepContinue,
                                      color: Colors.blueAccent,
                                      textColor: Colors.white,
                                      child: Text(
                                        '${this._currentStep == 2 ? 'CONFIRM' : 'NEXT'}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: onStepCancel,
                                      textColor: Colors.black87,
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Step> registrationSteps() {
    List<Step> steps = [
      Step(
        title: Text('Account'),
        isActive: _currentStep >= 0,
        content: Form(
          key: _registrationFormKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userType = USER_TYPE_DOCTOR;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/doctor.png',
                      title: 'Doctor',
                      elevation: _userType == USER_TYPE_DOCTOR ? 5.0 : 2.0,
                      backgroundColor: _userType == USER_TYPE_DOCTOR
                          ? Colors.blueAccent
                          : Colors.white,
                      textColor: _userType == USER_TYPE_DOCTOR
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
                        _userType = USER_TYPE_PATIENT;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/patient.png',
                      title: 'Patient',
                      elevation: _userType == USER_TYPE_PATIENT ? 5.0 : 2.0,
                      backgroundColor: _userType == USER_TYPE_PATIENT
                          ? Colors.blueAccent
                          : Colors.white,
                      textColor: _userType == USER_TYPE_PATIENT
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              _hasNotSelectedUserType
                  ? Text(
                      'Please select your account type',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                initialValue: _userEmail,
                focusNode: _userEmailFocus,
                onChanged: (val) {
                  setState(() {
                    _userEmail = val;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an email address.';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(_userEmail)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userEmailFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userPasswordFocus);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                initialValue: _userPassword,
                focusNode: _userPasswordFocus,
                obscureText: !_passwordVisible,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {
                    _userPassword = val;
                  });
                },
                validator: (value) {
                  if (value.length < 8) {
                    return 'Your password must be at least 8 characters long.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userPasswordFocus.unfocus();
                  FocusScope.of(context)
                      .requestFocus(_userConfirmPasswordFocus);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                initialValue: _userConfirmPassword,
                focusNode: _userConfirmPasswordFocus,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: !_confirmPasswordVisible,
                onChanged: (val) {
                  setState(() {
                    _userConfirmPassword = val;
                  });
                },
                validator: (value) {
                  if (value != _userPassword) {
                    return 'Your passwords don\'t match';
                  } else if (value.length < 8) {
                    return 'Your password must be at least 8 characters long.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userConfirmPasswordFocus.unfocus();
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text('Details'),
        isActive: _currentStep >= 1,
        content: Form(
          key: _detailsFormKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                initialValue: _userName,
                focusNode: _userNameFocus,
                onChanged: (val) {
                  setState(() {
                    _userName = val;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name.';
                  } else if (value.length < 3) {
                    return 'Please enter your full name.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userNameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userGenderFocus);
                },
              ),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('Male'),
                    value: 'Male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'Female',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _userGender = value;
                  });
                  _userGenderFocus.unfocus();
                },
                isExpanded: true,
                focusNode: _userGenderFocus,
                value: _userGender,
                validator: (value) {
                  print(value);
                  if (_userGender == null) {
                    return 'Please select a gender';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                controller: _userDOBController,
                focusNode: _userDOBFocus,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _showDateOfBirthPicker(context);
                  _userDOBFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userHeightFocus);
                },
                enableInteractiveSelection: false,
                validator: (value) {
                  if (_userDOB.compareTo(DateTime.now()) > 0) {
                    return 'Date of Birth cannot be in the future.';
                  } else if (_userDOB.compareTo(DateTime.now()) == 0) {
                    return 'Please enter a valid date of birth';
                  } else if (Age.dateDifference(
                        fromDate: _userDOB,
                        toDate: DateTime.now(),
                      ).years <
                      13) {
                    return 'You must be at least 13 years old to register';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Height',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffix: Container(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
                      child: Text(
                        'cm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                initialValue: _userHeight.toString() == "null"
                    ? ""
                    : _userHeight.toString(),
                focusNode: _userHeightFocus,
                onChanged: (val) {
                  setState(() {
                    _userHeight = double.parse(val);
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your height.';
                  } else if (_userHeight < 0) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userHeightFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userWeightFocus);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffix: Container(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
                      child: Text(
                        'Kg',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                initialValue: _userWeight.toString() == "null"
                    ? ""
                    : _userWeight.toString(),
                focusNode: _userWeightFocus,
                onChanged: (val) {
                  setState(() {
                    _userWeight = double.parse(val);
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your weight.';
                  } else if (_userWeight < 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userWeightFocus.unfocus();
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text('Finish'),
        isActive: _currentStep >= 2,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please Confirm Your Details',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: DoctorPatientCard(
                    imagePath: _userType == USER_TYPE_DOCTOR
                        ? 'assets/icons/doctor.png'
                        : 'assets/icons/patient.png',
                    title: _userType == USER_TYPE_DOCTOR ? 'Doctor' : 'Patient',
                    elevation: 2.0,
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DetailRow(
                        title: 'Name',
                        data: _userName,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Email',
                        data: _userEmail,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DetailRow(
                      data: _userDOBText,
                      title: 'Date of Birth',
                    ),
                  ),
                  Expanded(
                    child: DetailRow(
                      data: _userGender,
                      title: 'Gender',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DetailRow(
                      data: '${_userWeight.toString()}Kg',
                      title: 'Weight',
                    ),
                  ),
                  Expanded(
                    child: DetailRow(
                      data: '${_userHeight.toString()}cm',
                      title: 'Height',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
    return steps;
  }

  Future<Null> _showDateOfBirthPicker(BuildContext context) async {
    final DateTime pickedDOB = await showDatePicker(
      context: context,
      initialDate: _userDOB,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDOB != null && pickedDOB != _userDOB) {
      setState(() {
        _userDOB = pickedDOB;
        _userDOBText = DateFormat('dd/MM/yyyy').format(pickedDOB);
        _userDOBController.value = TextEditingValue(text: _userDOBText);
      });
      return null;
    }
    return null;
  }
}
