import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/patient/components/app_bar.dart';
import 'file:///C:/Coding/Flutter/flutter_doctorsprescription/lib/pages/patient/components/drawer.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PatientAppBar(
        title: 'Show QR',
      ),
      drawer: PatientDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            QrImage(
              data: "${patientBloc.currentPatient.uid}",
              version: QrVersions.auto,
              size: 320.0,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
