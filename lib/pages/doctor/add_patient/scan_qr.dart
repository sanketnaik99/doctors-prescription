import 'package:doctors_prescription/models/doctor.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/doctor/components/app_bar.dart';
import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/doctor/components/drawer.dart';

class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  String qrText = "";
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void closeQr() {
    controller?.dispose();
  }

  void _onQRViewCreate(QRViewController controller) async {
    this.controller = controller;
    final String newPatientID = await controller.scannedDataStream.first;
    print("PATIENT ID: " + newPatientID);
    scanSuccess(newPatientID);
  }

  void scanSuccess(scanData) {
    dispose();
    this.controller.dispose();
    Navigator.of(context).pushReplacementNamed(
      DOCTOR_SCAN_RESULT,
      arguments: QRScanResult(qrResult: scanData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(
        title: 'Add Patient',
      ),
      drawer: DoctorAppDrawer(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(
                        borderRadius: 10,
                        borderColor: Colors.blueAccent,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300),
                    onQRViewCreated: _onQRViewCreate,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Hero(
                  tag: 'addPatient',
                  child: Text(
                    'Place the QR code in the box.',
                    style: TextStyle(color: Colors.white, fontSize: 21.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
