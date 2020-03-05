import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_practice/pages/login.dart';
import 'package:flutter_practice/pages/registration.dart';

class FluroRouter {
  static Router router = Router();
  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());
  static Handler _registrationHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterPage());
  static void setupRouter() {
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'register',
      handler: _registrationHandler,
    );
  }
}
