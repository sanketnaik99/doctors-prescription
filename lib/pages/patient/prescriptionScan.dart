import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:doctors_prescription/components/cameraPreview.dart';
import 'package:doctors_prescription/components/cameraViewFinder.dart';
import 'package:doctors_prescription/main.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PrescriptionScan extends StatefulWidget {
  @override
  _PrescriptionScanState createState() => _PrescriptionScanState();
}

class _PrescriptionScanState extends State<PrescriptionScan> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  String imagePath;
  bool showCaptured = false;
  static final _base64SafeEncoder = const Base64Codec.urlSafe();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() {
    controller = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
    return;
  }

  Future<String> cropSquare(String srcFilePath, bool flip) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes);

    var cropSize = min(src.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    IMG.Image destImage =
        IMG.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    if (flip) {
      destImage = IMG.flipVertical(destImage);
    }
    final destFilePath = join((await getTemporaryDirectory()).path,
        '${DateTime.now().millisecondsSinceEpoch}.png');
    var jpg = IMG.encodeJpg(destImage);

    await File(destFilePath).writeAsBytes(jpg);
    return destFilePath;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: showCaptured
            ? CameraPreviewWidget(
                imagePath: imagePath,
                retry: () {
                  initializeCamera();
                  setState(() {
                    this.showCaptured = false;
                    this.imagePath = '';
                  });
                },
                upload: () {
                  print(imagePath);
                  final imagePathEncoded =
                      _base64SafeEncoder.encode(utf8.encode(imagePath));
                  patientBloc.scanPrescription(imagePath);
                  Navigator.pushNamed(context, 'scanResult/$imagePathEncoded');
                },
              )
            : CameraViewFinderWidget(
                initializeControllerFuture: _initializeControllerFuture,
                controller: controller,
                captureFunction: () async {
                  final path = join((await getTemporaryDirectory()).path,
                      '${DateTime.now().millisecondsSinceEpoch}.png');
                  await controller.takePicture(path);
                  imagePath = await cropSquare(path, false);
                  setState(() {
                    showCaptured = true;
                    controller.dispose();
                  });
                },
              ),
      ),
    );
  }
}
