//
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_shapes/flutter_shapes.dart';c
// import 'dart:ui' as ui;
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import '../Handler/Event.dart';
// import '../Handler/Image.dart';
// import 'Home.dart';
// import 'dart:io' show File;
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io' as io;
//
//
//
//
//
//
//
// class WritingPad extends StatefulWidget {
//   const WritingPad({Key? key}) : super(key: key);
//
//   @override
//   State<WritingPad> createState() => _WritingPadState();
// }
//
// class _WritingPadState extends State<WritingPad> {
//   ScreenshotController screenshotController = ScreenshotController();
//   GlobalKey _key = GlobalKey();
//   List<Uint8List> screenshotImages = [];
//
//
//
//
// // ...
//
//   Future<void> _captureAndSaveScreenshot() async {
//     screenshotController.capture().then((Uint8List? image) {
//       if (image != null) {
//         setState(() {
//           screenshotImages.add(image);
//         });
//
//         _showScreenshotNotification();
//       }
//     });
//   }
//
//
//
//
//
//
//
//
//   void _showScreenshotNotification() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Center(child: Text('Screenshot saved successfully!')),
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }
//
//
//
//
//   List<Segment> segments = [];
//   List<SlideData> slidesData = [];  //here slide limit is added;
//   int currentSlideIndex = 0;
//   void _addNewSlide() {
//     // if (slidesData.length < 10){
//     slidesData.add(SlideData(segments: [], segmentColors: [], redoSegments: []));
//     setState(() {
//       currentSlideIndex = slidesData.length - 1;
//     });
//   }
//
//
//   void _undo() {
//     if (slidesData.isNotEmpty) {
//       var segments = slidesData[currentSlideIndex].segments;
//       var redoSegments = slidesData[currentSlideIndex].redoSegments;
//       if (segments.isNotEmpty) {
//         var undoneSegment = segments.removeLast();
//         redoSegments.add(undoneSegment); // Add the undone segment to redoSegments
//         setState(() {});
//       }
//     }
//   }
//
//   void _redo() {
//     if (slidesData.isNotEmpty) {
//       var segments = slidesData[currentSlideIndex].segments;
//       var redoSegments = slidesData[currentSlideIndex].redoSegments;
//       if (redoSegments.isNotEmpty) {
//         var redoneSegment = redoSegments.removeLast();
//         segments.add(redoneSegment);
//         setState(() {});
//       }
//     }
//   }
//
//
//   List<Color> segmentColors = [];
//   Color currentColor = Colors.black;
//   List<Segment> segment = [];
//
//   final List<int> availableThicknesses = [2, 4, 6, 8, 10,];
//   int currentThickness = 2;
//
//   void _showThicknessOptions() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select pen thickness'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: availableThicknesses.map((thickness) {
//                 return ListTile(
//                   leading: Container(
//                     width: thickness.toDouble(), // Convert thickness to double for displaying the circle.
//                     height: thickness.toDouble(),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: currentColor,
//                     ),
//                   ),
//                   title: Text('$thickness'),
//                   onTap: () {
//                     setState(() {
//                       currentThickness = thickness;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   // Function to show the color picker
//   void _showColorPicker() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select a color'),
//           content: SingleChildScrollView(
//             child: ColorPicker(
//               pickerColor: currentColor,
//               onColorChanged: (Color color) {
//                 setState(() {
//                   currentColor = color;
//                 });
//               },
//               showLabel: true,
//               pickerAreaHeightPercent: 0.8,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Helper function to check if a point is within the canvas bounds
//   bool _isWithinCanvasBounds(Offset point, Size canvasSize) {
//     double halfThickness = currentThickness.toDouble() / 2; // Half of the line thickness
//
//     return point.dx >= halfThickness &&
//         point.dx <= canvasSize.width - halfThickness &&
//         point.dy >= halfThickness &&
//         point.dy <= canvasSize.height - halfThickness;
//   }
//
//
//   void _clearCanvas() {
//     setState(() {
//       slidesData[currentSlideIndex].segments.clear();
//       slidesData[currentSlideIndex].segmentColors.clear();
//     });
//   }
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//   @override
//   Widget build(BuildContext context) {
//     if (slidesData.isEmpty) {
//       slidesData.add(SlideData(
//         segments: [],
//         segmentColors: [],
//         redoSegments: [], // Add this line
//       ));
//     }
//
//     var segments = slidesData[currentSlideIndex].segments;
//     var segmentColors = slidesData[currentSlideIndex].segmentColors;
//     return Scaffold(
//
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         flexibleSpace: Padding(
//           padding: EdgeInsets.only(top: 18,), // Add the desired top padding
//           child: FlexibleSpaceBar(
//             title: Align(
//               alignment: Alignment.center,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 20,),
//                 child: Text(
//                   'Intelligent White Board',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             background: Image.asset('assets/icon/b1.png', fit: BoxFit.cover),
//           ),
//         ),
//         backgroundColor: Color.fromARGB(255, 245, 113, 76), // Set the background color
//       ),
//
//       body: Padding(
//
//         padding: EdgeInsets.only(top: 5, right: 8),
//         child: Row(
//           children: [
//
//             // Left column containing icons
//             Container(
//               width: 60,
//               child: ListView(
//                 children: [
//                   SizedBox(height: 16,),
//                   // Wrap each IconButton with a Column
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Home', // Text to be displayed in the tooltip
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/home.png'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => homescreen()),
//                             );
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ), // Add a horizontal divider
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Color',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/color.png'),
//                           onPressed: () {
//                             _showColorPicker(); // Handle Select Color Icon press
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Thickness',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/thickness.png'),
//                           onPressed: () {
//                             _showThicknessOptions();
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Eraser',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/eraser.png'),
//                           onPressed: () {
//                             // Handle Eraser Icon press
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Shape',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/shape.png'),
//                           onPressed: () {
//                             // Handle Shape Icon press
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Undo',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/undo.png'),
//                           onPressed: () {
//                             _undo(); // Handle Undo Icon press
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Tooltip(
//                         message: 'Redo',
//                         child: IconButton(
//                           icon: Image.asset('assets/icon/redo.png'),
//                           onPressed: () {
//                             _redo(); // Handle Redo Icon press
//                           },
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Images(screenshotImages: screenshotImages),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           width: 80,
//                           height: 40,
//                           child: Stack(
//                             children: [
//                               Center(
//                                 child: Image.asset(
//                                   'assets/icon/image.png', // Replace with the actual screenshot icon asset
//                                   //fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black87,
//                         endIndent: 0.00005,
//                       ),
//                     ],
//                   ),
//
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: _captureAndSaveScreenshot,
//                         child: Container(
//                           width: 80,
//                           height: 40,
//                           child: Stack(
//                             children: [
//                               Center(
//                                 child: Image.asset(
//                                   'assets/icon/screenshot.png', // Replace with the actual screenshot icon asset
//                                   //fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       Divider(
//                         color: Colors.black87,
//
//                         endIndent: 0.00005,
//                       ),
//                     ],),
//                   Column(
//                     children: [
//                       ElevatedButton(onPressed: (){
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => demo(slidesData: slidesData),
//                           ),
//                         );
//                       }, child: Text('Show')),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//
//             SizedBox(width: 1), // Add spacing between the columns
//
//             // Right column containing the canvas for drawing
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Text widget at the top
//                   Text('Slide ${currentSlideIndex + 1}',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold,color: Colors.black),),
//                   //SizedBox(height: 1), // Add spacing between text and canvas
//                   Expanded(
//                     child: Screenshot(
//                       controller: screenshotController,
//                       child: GestureDetector(
//                         // Use GestureDetector to handle touch events on the canvas
//                         onPanStart: (details) {
//                           Offset localPosition = details.localPosition;
//
//                           if (_isWithinCanvasBounds(localPosition, Size.infinite)) {
//                             setState(() {
//                               var newSegment = Segment(
//                                 points: [localPosition],
//                                 color: currentColor,
//                                 thickness: currentThickness,
//                                 slideNumber: currentSlideIndex, // Assign the current slide index
//                               );
//                               segments.add(newSegment);
//                             });
//                           }
//                         },
//
//                         onPanUpdate: (details) {
//                           Offset localPosition = details.localPosition;
//
//                           if (_isWithinCanvasBounds(localPosition, Size.infinite)) {
//                             setState(() {
//                               segments.last.points.add(localPosition);
//                             }
//                             );
//                           }
//                         },
//
//                         child: Container(
//                           color: Colors.white,
//                           child: CustomPaint(
//                             painter: _FreeHandPainter(segments),
//                             child: Center(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ), ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//
//             GestureDetector(
//               onTap: () {
//                 if (currentSlideIndex > 0) {
//                   setState(() {
//                     currentSlideIndex--;
//                   });
//                 } // Call your _clearCanvas function here
//               },
//               child: Container(
//                 width: 80,
//                 height: 40,
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/icon/clear.png',
//                       //fit: BoxFit.contain,
//                     ),
//                     Center(
//                       child: Text(
//                         'Prev',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox( width: 30),
//
//
//             GestureDetector(
//               onTap: () {
//
//                 _clearCanvas(); // Call your _clearCanvas function here
//               },
//               child: Container(
//                 width: 80,
//                 height: 40,
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/icon/nextslide.png',
//                       //fit: BoxFit.contain,
//                     ),
//                     Center(
//                       child: Text(
//                         'Clear',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox( width: 10),
//
//             GestureDetector(
//               onTap: () {
//                 _addNewSlide(); // Call your _clearCanvas function here
//
//               },
//               child: Container(
//                 width: 80,
//                 height: 40,
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/icon/nextslide.png',
//                       //fit: BoxFit.contain,
//                     ),
//                     Center(
//                       child: Text(
//                         'New Slide',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox( width: 40),
//             GestureDetector(
//               onTap: () {
//                 if (currentSlideIndex < slidesData.length - 1) {
//                   setState(() {
//                     currentSlideIndex++;
//                   });
//                 }
//               },
//               child: Container(
//                 width: 80,
//                 height: 40,
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/icon/clear.png',
//                       //fit: BoxFit.contain,
//                     ),
//                     Center(
//                       child: Text(
//                         ' Next ',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//
//           ],
//         ),
//       ),
//
//
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
// class _FreeHandPainter extends CustomPainter {
//   final List<Segment> segments;
//
//   _FreeHandPainter(this.segments);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var segment in segments) {
//       var paint = Paint()
//         ..color = segment.color
//         ..strokeCap = StrokeCap.round
//         ..strokeWidth = segment.thickness.toDouble();
//
//       for (int j = 0; j < segment.points.length - 1; j++) {
//         if (segment.points[j] != null && segment.points[j + 1] != null) {
//           canvas.drawLine(segment.points[j], segment.points[j + 1], paint);
//         }
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// class SlideData {
//   List<Segment> segments;
//   List<Color> segmentColors;
//   List<Segment> redoSegments; // Add redoSegments list
//
//   SlideData({
//     required this.segments,
//     required this.segmentColors,
//     required this.redoSegments, // Include redoSegments in the constructor
//   });
// }
//
// class Segment {
//   List<Offset> points;
//   Color color;
//   int thickness;
//   int slideNumber;
//   double fontSize; // Add fontSize property
//
//   Segment({
//     required this.points,
//     required this.color,
//     required this.thickness,
//     required this.slideNumber,
//     required this.fontSize, // Include fontSize in the constructor
//   });
// }