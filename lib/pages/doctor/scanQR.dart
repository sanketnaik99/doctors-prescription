import 'package:doctors_prescription/components/doctorAppBar.dart';
import 'package:doctors_prescription/components/doctorDrawer.dart';
import 'package:doctors_prescription/components/itemCard.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:flutter/material.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScannerPage> {
  String qrText = "";
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    final DoctorBloc doctorBloc = Provider.of<DoctorBloc>(context);
    return Scaffold(
      appBar: DoctorAppBar(title: 'Add Patient'),
      drawer: DoctorAppDrawer(),
      body: doctorBloc.isLoadingPatientData == false &&
              doctorBloc.hasNewPatientData == false
          ? Stack(
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
                                borderColor: Colors.red,
                                borderLength: 30,
                                borderWidth: 10,
                                cutOutSize: 300),
                            onQRViewCreated: _onQRViewCreate),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: Text(
                      'Place a QR code in front of the Camera',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                  ),
                ),
              ],
            )
          : doctorBloc.isLoadingPatientData == true &&
                  doctorBloc.hasNewPatientData == false
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              : doctorBloc.hasNewPatientData
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Patient to be added',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Wrap(
                              children: <Widget>[
                                ItemCard(
                                  avatarImage:
                                      AssetImage('assets/icons/patient.png'),
                                  backgroundColor: Colors.green.shade200,
                                  title: '${doctorBloc.newPatient.username}',
                                  content: [
                                    'Email: ${doctorBloc.newPatient.email}',
                                    'UID: ${doctorBloc.newPatient.uid}'
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: RaisedButton.icon(
                                  onPressed: () async {
                                    //TODO: FIX ASYNC ISSUE
                                    await doctorBloc.addNewPatient();
                                    doctorBloc.fetchPatients();
                                    Navigator.of(context).pushReplacementNamed(
                                        'doctorDashboard');
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Add Patient'),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Text("AN ERROR OCCURRED"),
    );
  }

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
    newPatient(newPatientID);
  }

  void newPatient(scanData) {
    Provider.of<DoctorBloc>(context, listen: false)
        .fetchNewPatientData(scanData);
    closeQr();
  }
}
