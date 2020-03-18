import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_practice/pages/home.dart';
import 'package:flutter_practice/pages/login.dart';
import 'package:flutter_practice/pages/qrCode.dart';
import 'package:flutter_practice/pages/qrScanner.dart';
import 'package:flutter_practice/pages/registration.dart';

class FluroRouter {
  static Router router = Router();
  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());
  static Handler _registrationHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterPage());
  static Handler _HomeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static Handler _QrCodeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          QrCodePage());
  static Handler _QrScannerHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          QrScannerPage());
  static void setupRouter() {
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'register',
      handler: _registrationHandler,
    );
    router.define(
      'home',
      handler: _HomeHandler,
    );
    router.define(
      'qrCode',
      handler: _QrCodeHandler,
    );
    router.define('qrScanner', handler: _QrScannerHandler);
  }
}
