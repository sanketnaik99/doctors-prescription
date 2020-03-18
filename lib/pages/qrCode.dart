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
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(
          "Show QR",
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              "Place a QR Code in front of the Camera",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            SizedBox(height: 130.0),
            QrImage(
              data: "12345678",
              version: QrVersions.auto,
              size: 250.0,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Prescription",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
