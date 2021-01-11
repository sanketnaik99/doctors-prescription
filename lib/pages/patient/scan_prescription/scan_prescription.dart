import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:doctors_prescription/main.dart';
import 'package:doctors_prescription/models/patient.dart';
import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PatientScanPrescription extends StatefulWidget {
  final Future<void> initializeControllerFuture;
  final CameraController controller;
  final Function captureFunction;

  PatientScanPrescription({
    this.initializeControllerFuture,
    this.controller,
    this.captureFunction,
  });
  @override
  _PatientScanPrescriptionState createState() =>
      _PatientScanPrescriptionState();
}

class _PatientScanPrescriptionState extends State<PatientScanPrescription>
    with WidgetsBindingObserver {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  String imagePath;
  bool _isLoading = false;
  static final _base64SafeEncoder = const Base64Codec.urlSafe();
  Isolate _isolate;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    controller = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
    return;
  }

  Future<String> cropSquare(String srcFilePath) async {
    File image = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.green,
        toolbarColor: Colors.green,
        toolbarTitle: 'Crop Image',
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: srcFilePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    String destFilePath;
    if (image != null) {
      destFilePath = join((await getTemporaryDirectory()).path,
          '${DateTime.now().millisecondsSinceEpoch}.png');
      final File finalImage = await image.copy(destFilePath);
    }

    return destFilePath;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        controller = CameraController(cameras[0], ResolutionPreset.max);
        _initializeControllerFuture = controller.initialize();
      });
    }
  }

  captureImage(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final path = join((await getTemporaryDirectory()).path,
        '${DateTime.now().millisecondsSinceEpoch}.png');
    await controller.takePicture(path);
    imagePath = await cropSquare(path);
    if (imagePath != null) {
      setState(() {
        //controller.dispose();
      });
      Navigator.of(context).pushReplacementNamed(
        PATIENT_SCAN_RESULT,
        arguments: PatientScanImageResult(
          imagePath: imagePath,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: 'Scan Prescription'),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final size = MediaQuery.of(context).size;
              final deviceRatio = size.width / size.height;
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 80.0,
                    child: Center(
                      child: Text(
                        'Place a prescription in front of the camera',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: _isLoading
                              ? SizedBox()
                              : CameraPreview(controller),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                  iconSize: 70.0,
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  onPressed: () async {
                                    captureImage(context);
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
