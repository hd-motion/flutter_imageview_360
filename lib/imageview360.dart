library imageview360;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum RotationDirection { clockwise, anticlockwise }

class ImageView360 extends StatefulWidget {
  final List<AssetImage> imageList;
  final bool autoRotate, allowSwipeToRotate;
  final int rotationCount;
  final Duration frameChangeDuration;
  final int swipeSensitivity;
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
  int rotationIndex;
  int rotationCompleted = 0;
  double globalPosition = 0.0;
  int senstivity;
  @override
  void initState() {
    senstivity = widget.swipeSensitivity;
    if (senstivity < 1) {
      senstivity = 1;
    } else if (senstivity > 5) {
      senstivity = 5;
    }
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
        GestureDetector(
          onHorizontalDragEnd: (details) {
            globalPosition = 0.0;
          },
          onHorizontalDragUpdate: (details) {
            if (widget.allowSwipeToRotate) {
              if (details.delta.dx > 0) {
                int val = rotationIndex;
                if ((globalPosition +
                        (pow(4, (6 - senstivity)) /
                            (widget.imageList.length))) <=
                    details.localPosition.dx) {
                  val = rotationIndex + 1;
                  globalPosition = details.localPosition.dx;
                }
                setState(() {
                  if (val < widget.imageList.length - 1) {
                    rotationIndex = val;
                  } else {
                    rotationIndex = 0;
                  }
                });
              } else if (details.delta.dx < 0) {
                print(details.globalPosition.dx);
                int val = rotationIndex;
                double diff = (details.localPosition.dx - globalPosition);
                if (diff < 0) {
                  diff = (-diff);
                }
                if (diff >=
                    (pow(4, (6 - senstivity)) / (widget.imageList.length))) {
                  val = rotationIndex - 1;
                  globalPosition = details.localPosition.dx;
                }
                setState(() {
                  if (val > 0) {
                    rotationIndex = val;
                  } else {
                    rotationIndex = widget.imageList.length - 1;
                  }
                });
              }
            }
          },
          child: Image(image: widget.imageList[rotationIndex]),
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

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
