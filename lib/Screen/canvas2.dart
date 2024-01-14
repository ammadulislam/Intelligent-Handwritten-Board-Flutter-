import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Canvas2 extends StatefulWidget {
  @override
  State<Canvas2> createState() => _Canvas2State();
}

class _Canvas2State extends State<Canvas2> {
  late double canvasWidth;
  late double canvasHeight;
  late EdgeInsets padding;

  late ScreenshotController screenshotController;

  List<Uint8List> screenshotImages = [];

  List<SlideData> slidesData = [];
  int currentSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
    slidesData.add(SlideData(segments: [], redoSegments: []));
  }

  double? savedImageWidth;
  double? savedImageHeight;

  void Screenshhot() async {
    try {
      Uint8List? image = await screenshotController.capture();
      if (image != null) {
        setState(() {
          screenshotImages.add(image);

          // Store the dimensions of the canvas
          savedImageWidth = 340;
          savedImageHeight = 250;
        });

        Notification();
      }
    } catch (e) {
      print("Error capturing screenshot: $e");
    }
  }



  void _showSavedImage() {
    if (screenshotImages.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: Image.memory(
                screenshotImages.last,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }



  void Notification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('Screenshot saved ')),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _undo() {
    if (slidesData.isNotEmpty) {
      var undoSegments = slidesData[currentSlideIndex].segments;
      var redoSegments = slidesData[currentSlideIndex].redoSegments;

      if (undoSegments.isNotEmpty) {
        var undoneSegment = undoSegments.removeLast();
        redoSegments.add(undoneSegment);
        setState(() {});
      }
    }
  }

  void _redo() {
    if (slidesData.isNotEmpty) {
      var undoSegments = slidesData[currentSlideIndex].segments;
      var redoSegments = slidesData[currentSlideIndex].redoSegments;

      if (redoSegments.isNotEmpty) {
        var redoneSegment = redoSegments.removeLast();
        undoSegments.add(redoneSegment);
        setState(() {});
      }
    }
  }

  void _clearCanvas() {
    setState(() {
      slidesData[currentSlideIndex].segments.clear();
      slidesData[currentSlideIndex].redoSegments.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    // Set canvas dimensions to occupy the entire screen
    canvasWidth = MediaQuery.of(context).size.width;
    canvasHeight = MediaQuery.of(context).size.height;
    padding = EdgeInsets.zero;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title and actions
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: _undo,
            ),
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: _redo,
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearCanvas,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: Screenshhot,
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: _showSavedImage,
            ),
          ],
        ),
        // Set a fixed height for the AppBar
        toolbarHeight: 20, // Set your desired height
      ),
      body: Center(
        child: RepaintBoundary(
          key: GlobalKey(),
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              width: canvasWidth,
              height: canvasHeight,
              color: Colors.grey,
              child: Stack(
                children: [
                  GestureDetector(
                    onPanStart: (details) {
                      Offset localPosition =
                          details.localPosition - Offset(padding.right, padding.top);

                      setState(() {
                        int segmentId = slidesData[currentSlideIndex].segments.length + 1;
                        var newSegment = Segment(
                          id: segmentId,
                          points: [localPosition],
                          color: Colors.black,
                          thickness: 4,
                        );
                        slidesData[currentSlideIndex].segments.add(newSegment);
                      });
                    },
                    onPanUpdate: (details) {
                      Offset localPosition =
                          details.localPosition - Offset(padding.right, padding.top);

                      setState(() {
                        var lastSegment = slidesData[currentSlideIndex].segments.last;
                        lastSegment.points.add(localPosition);
                      });
                    },
                    child: CustomPaint(
                      painter: _FreeHandPainter(slidesData[currentSlideIndex].segments),
                      child: Center(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FreeHandPainter extends CustomPainter {
  final List<Segment> segments;

  _FreeHandPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    for (var segment in segments) {
      var paint = Paint()
        ..color = segment.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = segment.thickness.toDouble();

      if (segment.points.isNotEmpty) {
        canvas.drawPoints(PointMode.polygon, segment.points, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SlideData {
  List<Segment> segments;
  List<Segment> redoSegments;

  SlideData({
    required this.segments,
    required this.redoSegments,
  });
}

class Segment {
  int id;
  List<Offset> points;
  Color color;
  int thickness;

  Segment({
    required this.id,
    required this.points,
    required this.color,
    required this.thickness,
  });
}
