import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code",
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: QrImage(
          data: "12345678",
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
