// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
//
// class MyScreen extends StatefulWidget {
//   @override
//   _MyScreenState createState() => _MyScreenState();
// }
//
// class _MyScreenState extends State<MyScreen> {
//   ScreenshotController screenshotController = ScreenshotController();
//   List<Uint8List> screenshotList = [];
//
//   void _captureAndSaveScreenshot() async {
//     Uint8List? screenshot = await screenshotController.capture();
//     if (screenshot != null) {
//       setState(() {
//         screenshotList.add(screenshot);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Screenshot Example'),
//       ),
//       body: Column(
//         children: [
//           Screenshot(
//             controller: screenshotController,
//             child: Container(
//               color: Colors.white,
//               child: Center(
//                 child: Text('This is your canvas or content'),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _captureAndSaveScreenshot,
//             child: Text('Capture and Save Screenshot'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: screenshotList.length,
//               itemBuilder: (context, index) {
//                 return Image.memory(screenshotList[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
