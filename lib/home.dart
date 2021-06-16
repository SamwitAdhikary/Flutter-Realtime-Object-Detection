import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'bndbox.dart';
import 'camera.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;

    res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet_v1_1_metadata_1.tflite",
        labels: "assets/ssd_mobilenet.txt");

    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    // color: Colors.teal,
                    child: const Text(
                      ssd,
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => onSelect(yolo),
                  ),
                  // ElevatedButton(
                  //   // color: Colors.teal,
                  //   child: const Text(
                  //     yolo,
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  //   onPressed: () => onSelect(yolo),
                  // ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                  _recognitions == null ? [] : _recognitions,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                  _model
                )
              ],
            ),
    );
  }
}
