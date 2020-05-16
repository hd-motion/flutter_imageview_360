library imageview360;

import 'dart:math';

import 'package:flutter/material.dart';

enum RotationDirection { clockwise, anticlockwise }

class ImageView360 extends StatefulWidget {
  final List<AssetImage> imageList;
  final bool autoRotate;
  final int rotationCount;
  final Duration frameChangeDuration;
  final int swipeSensitivity;
  final RotationDirection rotationDirection;
  ImageView360({
    @required Key key,
    @required this.imageList,
    this.autoRotate = false,
    this.rotationCount = 1,
    this.swipeSensitivity = 1,
    this.rotationDirection = RotationDirection.clockwise,
    this.frameChangeDuration = const Duration(milliseconds: 50),
  }) : super(key: key);
  @override
  _ImageView360State createState() => _ImageView360State();
}

class _ImageView360State extends State<ImageView360> {
  int rotationIndex;
  int rotationCompleted = 0;
  @override
  void initState() {
    rotationIndex = widget.rotationDirection == RotationDirection.anticlockwise
        ? 0
        : (widget.imageList.length - 1);
    if (widget.autoRotate) {
      rotateImage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Container(
        //   // color: Colors.green,
        //   width: double.maxFinite,
        //   // height: 100,
        //   child: Image(image: widget.imageList[rotationIndex]),
        // ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              int val = rotationIndex +
                  ((details.delta.dx * (0.001)) *
                          pow(2, widget.swipeSensitivity))
                      .ceil();
              setState(() {
                if (val < 51) {
                  rotationIndex = val;
                } else {
                  rotationIndex = 0;
                }
              });
            } else if (details.delta.dx < 0) {
              int val = rotationIndex -
                  ((details.delta.dx * (-0.001)) *
                          pow(2, widget.swipeSensitivity))
                      .ceil();
              setState(() {
                if (val > 0) {
                  rotationIndex = val;
                } else {
                  rotationIndex = 51;
                }
              });
            }
          },
          child: Container(
            // color: Colors.green,
            width: double.maxFinite,
            // height: 100,
            child: Image(image: widget.imageList[rotationIndex]),
          ),
        ),
      ],
    );
  }

  void rotateImage() async {
    if (rotationCompleted < widget.rotationCount) {
      await Future.delayed(widget.frameChangeDuration);
      if (mounted) {
        setState(() {
          if (widget.rotationDirection == RotationDirection.anticlockwise) {
            if (rotationIndex < widget.imageList.length - 1) {
              rotationIndex++;
            } else {
              rotationCompleted++;
              rotationIndex = 0;
            }
          } else {
            if (rotationIndex > 0) {
              rotationIndex--;
            } else {
              rotationCompleted++;
              rotationIndex = widget.imageList.length - 1;
            }
          }
        });
      }
      rotateImage();
    }
  }
}
