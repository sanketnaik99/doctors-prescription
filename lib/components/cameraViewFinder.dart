import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewFinderWidget extends StatelessWidget {
  CameraViewFinderWidget(
      {this.initializeControllerFuture, this.controller, this.captureFunction});

  final Future<void> initializeControllerFuture;
  final CameraController controller;
  final Function captureFunction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final size = MediaQuery.of(context).size;
          final deviceRatio = size.width / size.height;
          return Stack(
            children: <Widget>[
              Transform.scale(
                scale: controller.value.aspectRatio / deviceRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Place a prescription in front of the camera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  iconSize: 70.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: this.captureFunction,
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
