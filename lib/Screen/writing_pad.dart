import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';
import '../Handler/Event.dart';
import '../Handler/Image.dart';

import 'dart:io' show File;

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:io' as io;

import 'canvas2.dart';







class WritingPad extends StatefulWidget {
  final String selectedSubject;
  final String selectedLectureNo;
  final int selectedSection;
  final int id;


  WritingPad({required this.selectedSubject, required this.selectedLectureNo,required this.selectedSection,required this.id});

  @override
  State<WritingPad> createState() => _WritingPadState();
}

class _WritingPadState extends State<WritingPad> {
  OverlayEntry? _overlayEntry;
  bool isDialogVisible = false;

  void _toggleDialogVisibility() {
    setState(() {
      isDialogVisible = !isDialogVisible;
    });

    if (isDialogVisible) {
      _showCanvasDialog();
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showCanvasDialog() {
    final double targetDx = 25;
    final double targetDy = 60;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: targetDy,
        left: targetDx,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 340, // Adjust the width as needed
            height: 250, // Adjust the height as needed
            padding: EdgeInsets.all(10),
            child: CanvasScreen(), // Use the CanvasScreen widget here
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }























  late double canvasWidth=0;
  late double canvasHeight=0;


  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _key = GlobalKey();

  List<Uint8List> screenshotImages = [];

  Future<void> _captureAndSaveScreenshot() async {
    screenshotController.capture().then((Uint8List? image) {
      if (image != null) {
        setState(() {
          screenshotImages.add(image);
        });

        _showScreenshotNotification();
      }
    });
  }








  void _showScreenshotNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('Screenshot saved successfully!')),
        duration: Duration(seconds: 1),
      ),
    );
  }




  List<Segment> segments = [];
  List<SlideData> slidesData = [];  //here slide limit is added;
  int currentSlideIndex = 0;


 void _resetSegments() {
   setState(() {
     slidesData[currentSlideIndex].segments.clear();
     slidesData[currentSlideIndex].segmentColors.clear();
   });
 }

 void _addNewSlide() {
   slidesData.add(SlideData(segments: [], segmentColors: [], redoSegments: []));
   setState(() {
     currentSlideIndex = slidesData.length - 1;
     _resetSegments(); // Reset the segments for the new slide
   });
 }



 void _undo() {
    if (slidesData.isNotEmpty) {
      var segments = slidesData[currentSlideIndex].segments;
      var redoSegments = slidesData[currentSlideIndex].redoSegments;
      if (segments.isNotEmpty) {
        var undoneSegment = segments.removeLast();
        redoSegments.add(undoneSegment); // Add the undone segment to redoSegments
        setState(() {});
      }
    }
  }

  void _redo() {
    if (slidesData.isNotEmpty) {
      var segments = slidesData[currentSlideIndex].segments;
      var redoSegments = slidesData[currentSlideIndex].redoSegments;
      if (redoSegments.isNotEmpty) {
        var redoneSegment = redoSegments.removeLast();
        segments.add(redoneSegment);
        setState(() {});
      }
    }
  }


  List<Color> segmentColors = [];
  Color currentColor = Colors.black;
  List<Segment> segment = [];

  final List<int> availableThicknesses = [2, 3, 4, 5,6 ,];
  int currentThickness = 4;

  void _showThicknessOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select pen thickness'),
          content: SingleChildScrollView(
            child: Column(
              children: availableThicknesses.map((thickness) {
                return ListTile(
                  leading: Container(
                    width: thickness.toDouble(), // Convert thickness to double for displaying the circle.
                    height: thickness.toDouble(),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentColor,
                    ),
                  ),
                  title: Text('$thickness'),
                  onTap: () {
                    setState(() {
                      currentThickness = thickness;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }


  // Function to show the color picker
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  currentColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper function to check if a point is within the canvas bounds
  bool _isWithinCanvasBounds(Offset point, Size canvasSize) {
    double halfThickness = currentThickness.toDouble() / 2; // Half of the line thickness

    return point.dx >= halfThickness &&
        point.dx <= canvasSize.width - halfThickness &&
        point.dy >= halfThickness &&
        point.dy <= canvasSize.height - halfThickness;
  }


  void _clearCanvas() {
    setState(() {
      slidesData[currentSlideIndex].segments.clear();
      slidesData[currentSlideIndex].segmentColors.clear();
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (slidesData.isEmpty) {
      slidesData.add(SlideData(
        segments: [],
        segmentColors: [],
        redoSegments: [], // Add this line
      ));
    }

    var segments = slidesData[currentSlideIndex].segments;
    var segmentColors = slidesData[currentSlideIndex].segmentColors;
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 18,), // Add the desired top padding
          child: FlexibleSpaceBar(
            title: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20,),
                // child: Text(
                //   'Intelligent White Board',
                //   style: TextStyle(fontSize: 20),
                // ),
              ),
            ),
            background: Image.asset('assets/icon/heading.png', fit: BoxFit.cover),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 245, 113, 76), // Set the background color
      ),

      body: Padding(

        padding: EdgeInsets.only(top: 5, right: 8),
        child: Row(
          children: [

            // Left column containing icons
            Container(
              width: 60,
              child: ListView(
                children: [
                  SizedBox(height: 16,),
                  // Wrap each IconButton with a Column
                  Column(
                    children: [
                      Tooltip(
                        message: 'Home', // Text to be displayed in the tooltip
                        child: IconButton(
                          icon: Image.asset('assets/icon/home.png'),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => homescreen()),
                            // );
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ), // Add a horizontal divider
                    ],
                  ),
                  Column(
                    children: [
                      Tooltip(
                        message: 'Color',
                        child: IconButton(
                          icon: Image.asset('assets/icon/color.png'),
                          onPressed: () {
                            _showColorPicker(); // Handle Select Color Icon press
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Tooltip(
                        message: 'Thickness',
                        child: IconButton(
                          icon: Image.asset('assets/icon/thickness.png'),
                          onPressed: () {
                            _showThicknessOptions();
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Tooltip(
                        message: 'Eraser',
                        child: IconButton(
                          icon: Image.asset('assets/icon/eraser.png'),
                          onPressed: () {
                            // Handle Eraser Icon press
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Tooltip(
                        message: 'AllScreenShoot',
                        child: IconButton(
                          icon: Image.asset('assets/icon/shape.png'),
                          onPressed: () {
                            _toggleDialogVisibility();
                          }
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Tooltip(
                        message: 'Undo',
                        child: IconButton(
                          icon: Image.asset('assets/icon/undo.png'),
                          onPressed: () {
                            _undo(); // Handle Undo Icon press
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Tooltip(
                        message: 'Redo',
                        child: IconButton(
                          icon: Image.asset('assets/icon/redo.png'),
                          onPressed: () {
                            _redo(); // Handle Redo Icon press
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Images(
                                  slidesData: slidesData,
                                  selectedSubject: widget.selectedSubject,
                                  selectedLectureNo: widget.selectedLectureNo,
                                  selectedSection: widget.selectedSection,
                                  screenshotImages: screenshotImages,
                                  id:widget.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 40,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/icon/image.png', // Replace with the actual screenshot icon asset
                                  //fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black87,
                        endIndent: 0.00005,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _captureAndSaveScreenshot,
                        child: Container(
                          width: 80,
                          height: 40,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/icon/screenshot.png', // Replace with the actual screenshot icon asset
                                  //fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(
                        color: Colors.black87,

                        endIndent: 0.00005,
                      ),
                    ],),
                  Column(
                    children: [
                      ElevatedButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventScreen(
                              slidesData: slidesData,
                              selectedSubject: widget.selectedSubject,
                              selectedLectureNo: widget.selectedLectureNo,
                              selectedSection: widget.selectedSection,
                            ),
                          ),
                        );
                      }, child: Text('Show')),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(width: 1), // Add spacing between the columns

            // Right column containing the canvas for drawing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Subject: ${widget.selectedSubject}',style:TextStyle(fontSize: 12,fontWeight:FontWeight.bold,color: Colors.black),),
                      SizedBox(width: 4,),
                      Text('Lec: ${widget.selectedLectureNo}',style:TextStyle(fontSize: 12,fontWeight:FontWeight.bold,color: Colors.black),),
                      SizedBox(width: 8,),
                      Text('Slide ${currentSlideIndex + 1}',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.blue),),


                             ],
                  ),

                  //SizedBox(height: 1), // Add spacing between text and canvas
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                         canvasWidth = constraints.maxWidth;
                         canvasHeight = constraints.maxHeight;
                          print('Canvas Width: $canvasWidth');
                          print('Canvas Height: $canvasHeight');

                        return Screenshot(
                          controller: screenshotController,
                          child: GestureDetector(
                            // Use GestureDetector to handle touch events on the canvas
                            onPanStart: (details) {
                              Offset localPosition = details.localPosition;

                               if (_isWithinCanvasBounds(localPosition, Size.infinite)) {
                              setState(() {
                              int segmentId = segments.length + 1; // Assign a unique ID to the segment
                              var newSegment = Segment(
                              id: segmentId,
                              points: [localPosition],
                              startPoint: localPosition,
                              color: currentColor,
                              thickness: currentThickness,
                              slideNumber: currentSlideIndex,
                              );
                              segments.add(newSegment); // Add the new segment to the list of segments
                                });
                              }
                            },
                            onPanUpdate: (details) {
                              Offset localPosition = details.localPosition;

                              if (_isWithinCanvasBounds(localPosition, Size.infinite)) {
                                setState(() {
                                  var lastSegment = segments.last;
                                  lastSegment.points.add(localPosition); // Add the current point to the points list
                                });
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              child: CustomPaint(
                                painter: _FreeHandPainter(segments),
                                child: Center(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            GestureDetector(
              onTap: () {
                if (currentSlideIndex > 0) {
                  setState(() {
                    currentSlideIndex--;
                  });
                } // Call your _clearCanvas function here
              },
              child: Container(
                width: 80,
                height: 40,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icon/clear.png',
                      //fit: BoxFit.contain,
                    ),
                    Center(
                      child: Text(
                        'Prev',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox( width: 30),


            GestureDetector(
              onTap: () {

                _clearCanvas(); // Call your _clearCanvas function here
              },
              child: Container(
                width: 80,
                height: 40,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icon/nextslide.png',
                      //fit: BoxFit.contain,
                    ),
                    Center(
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox( width: 10),

            GestureDetector(
              onTap: () {
                _addNewSlide(); // Call your _clearCanvas function here

              },
              child: Container(
                width: 80,
                height: 40,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icon/nextslide.png',
                      //fit: BoxFit.contain,
                    ),
                    Center(
                      child: Text(
                        'New Slide',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox( width: 40),
            GestureDetector(
              onTap: () {
                if (currentSlideIndex < slidesData.length - 1) {
                  setState(() {
                    currentSlideIndex++;
                  });
                }
              },
              child: Container(
                width: 80,
                height: 40,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icon/clear.png',
                      //fit: BoxFit.contain,
                    ),
                    Center(
                      child: Text(
                        ' Next ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),


    );
  }
}

class _FreeHandPainter extends CustomPainter {
  final List<Segment> segments;

  _FreeHandPainter(this.segments);

  Offset formatOffset(Offset offset) {
    const int decimalPlaces = 3;
    double formattedX = double.parse(offset.dx.toStringAsFixed(decimalPlaces));
    double formattedY = double.parse(offset.dy.toStringAsFixed(decimalPlaces));
    return Offset(formattedX, formattedY);
  }



  @override
  void paint(Canvas canvas, Size size) {
   // drawGrid(canvas, size, 10.0); // Adjust the cellSize as per your preference

    for (var segment in segments) {
      var paint = Paint()
        ..color = segment.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = segment.thickness.toDouble();

      for (int j = 0; j < segment.points.length - 1; j++) {
        if (segment.points[j] != null && segment.points[j + 1] != null) {
          final startPoint = formatOffset(segment.points[j]);
          final endPoint = formatOffset(segment.points[j + 1]);

          canvas.drawLine(startPoint, endPoint, paint);
        }
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
  List<Color> segmentColors;
  List<Segment> redoSegments; // Add redoSegments list

  SlideData({
    required this.segments,
    required this.segmentColors,
    required this.redoSegments, // Include redoSegments in the constructor
  });
}
class Segment {
  int id; // Unique identifier for the segment
  List<Offset> points;
  Offset startPoint;
  Color color;
  int thickness;
  int slideNumber;

  Segment({
    required this.id,
    required this.points,
    required this.startPoint,
    required this.color,
    required this.thickness,
    required this.slideNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startPoint': {'dx': startPoint.dx, 'dy': startPoint.dy},
      'color': color.value.toRadixString(16), // Convert color to string or use another representation
      'thickness': thickness,
      'slideNumber': slideNumber,
    };
  }

}
class CanvasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Canvas2();
  }
}
