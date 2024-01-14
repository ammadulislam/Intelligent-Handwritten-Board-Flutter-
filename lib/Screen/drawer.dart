// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DrawingCanvas(),
//     );
//   }
// }
//
// class DrawingCanvas extends StatefulWidget {
//   @override
//   _DrawingCanvasState createState() => _DrawingCanvasState();
// }
//
// class _DrawingCanvasState extends State<DrawingCanvas> {
//   List<Offset> drawnPoints = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Drawing Canvas'),
//       ),
//       body: GestureDetector(
//         onPanUpdate: (details) {
//           setState(() {
//             Offset localPosition = details.localPosition;
//             drawnPoints.add(localPosition);
//           });
//         },
//         child: CustomPaint(
//           painter: DrawingPainter(drawnPoints),
//           child: Container(),
//         ),
//       ),
//     );
//   }
// }
//
// class DrawingPainter extends CustomPainter {
//   final List<Offset> points;
//
//   DrawingPainter(this.points);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 5.0;
//
//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i], points[i + 1], paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
