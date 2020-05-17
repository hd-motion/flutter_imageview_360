library imageview360;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Enum for rotation direction
enum RotationDirection { clockwise, anticlockwise }

class ImageView360 extends StatefulWidget {
  final List<AssetImage> imageList;
  final bool autoRotate, allowSwipeToRotate;
  final int rotationCount, swipeSensitivity;
  final Duration frameChangeDuration;
  final RotationDirection rotationDirection;

  ImageView360({
    @required Key key,
    @required this.imageList,
    this.autoRotate = false,
    this.allowSwipeToRotate = true,
    this.rotationCount = 1,
    this.swipeSensitivity = 1,
    this.rotationDirection = RotationDirection.clockwise,
    this.frameChangeDuration = const Duration(milliseconds: 80),
  }) : super(key: key);

  @override
  _ImageView360State createState() => _ImageView360State();
}

class _ImageView360State extends State<ImageView360> {
  int rotationIndex, senstivity;
  int rotationCompleted = 0;
  double localPosition = 0.0;

  @override
  void initState() {
    senstivity = widget.swipeSensitivity;
    // To bound the sensitivity range from 1-5
    if (senstivity < 1) {
      senstivity = 1;
    } else if (senstivity > 5) {
      senstivity = 5;
    }

    rotationIndex = widget.rotationDirection == RotationDirection.anticlockwise
        ? 0
        : (widget.imageList.length - 1);

    if (widget.autoRotate) {
      // To start the image rotation
      rotateImage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onHorizontalDragEnd: (details) {
            localPosition = 0.0;
          },
          onHorizontalDragUpdate: (details) {
            // Swipe check,if allowed than only will image move
            if (widget.allowSwipeToRotate) {
              if (details.delta.dx > 0) {
                handleRightSwipe(details);
              } else if (details.delta.dx < 0) {
                handleLeftSwipe(details);
              }
            }
          },
          child: Image(image: widget.imageList[rotationIndex]),
        ),
      ],
    );
  }

  void rotateImage() async {
    // Check for rotationCount
    if (rotationCompleted < widget.rotationCount) {
      // Frame change duration logic
      await Future.delayed(widget.frameChangeDuration);
      if (mounted) {
        setState(() {
          if (widget.rotationDirection == RotationDirection.anticlockwise) {
            // Logic to bring the frame to initial position on cycle complete in positive direction
            if (rotationIndex < widget.imageList.length - 1) {
              rotationIndex++;
            } else {
              rotationCompleted++;
              rotationIndex = 0;
            }
          } else {
            // Logic to bring the frame to initial position on cycle complete in negative direction
            if (rotationIndex > 0) {
              rotationIndex--;
            } else {
              rotationCompleted++;
              rotationIndex = widget.imageList.length - 1;
            }
          }
        });
      }
      //Recursive call
      rotateImage();
    }
  }

  void handleRightSwipe(DragUpdateDetails details) {
    if ((localPosition +
            (pow(4, (6 - senstivity)) / (widget.imageList.length))) <=
        details.localPosition.dx) {
      rotationIndex = rotationIndex + 1;
      localPosition = details.localPosition.dx;
    }
    setState(() {
      if (rotationIndex < widget.imageList.length - 1) {
        rotationIndex = rotationIndex;
      } else {
        rotationIndex = 0;
      }
    });
  }

  void handleLeftSwipe(DragUpdateDetails details) {
    double distancedifference = (details.localPosition.dx - localPosition);
    if (distancedifference < 0) {
      distancedifference = (-distancedifference);
    }
    if (distancedifference >=
        (pow(4, (6 - senstivity)) / (widget.imageList.length))) {
      rotationIndex = rotationIndex - 1;
      localPosition = details.localPosition.dx;
    }
    setState(() {
      if (rotationIndex > 0) {
        rotationIndex = rotationIndex;
      } else {
        rotationIndex = widget.imageList.length - 1;
      }
    });
  }
}
