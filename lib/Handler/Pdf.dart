// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
// import 'package:path/path.dart' as p;
//
// void main() => runApp(MaterialApp(
//   home: MyApp(),
// ));
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isLoading = true;
//   late PDFDocument document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }
//
//   loadDocument() async {
//     document = await PDFDocument.fromAsset('assets/sample.pdf');
//     setState(() => _isLoading = false);
//   }
//
//   changePDF(value) async {
//     setState(() => _isLoading = true);
//     if (value == 1) {
//       document = await PDFDocument.fromAsset('assets/sample2.pdf');
//     } else if (value == 2) {
//       document = await PDFDocument.fromURL(
//         "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
//       );
//     } else {
//       document = await PDFDocument.fromAsset('assets/sample.pdf');
//     }
//     setState(() => _isLoading = false);
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 36),
//             ListTile(
//               title: Text('Load from Assets'),
//               onTap: () {
//                 changePDF(1);
//               },
//             ),
//             ListTile(
//               title: Text('Load from URL'),
//               onTap: () {
//                 changePDF(2);
//               },
//             ),
//             ListTile(
//               title: Text('Restore default'),
//               onTap: () {
//                 changePDF(3);
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text('FlutterPluginPDFViewer'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : PDFViewer(
//           document: document,
//           zoomSteps: 1,
//         ),
//       ),
//     );
//   }
// }
//
// class PdfScreen extends StatefulWidget {
//   @override
//   _PdfScreenState createState() => _PdfScreenState();
// }
//
// class _PdfScreenState extends State<PdfScreen> {
//   List<Map<String, dynamic>> pdfs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPDFs();
//   }
//
//   Future<void> fetchPDFs() async {
//     final response =
//     await http.get(Uri.parse('http://192.168.1.230:5000/getPDFs'));
//
//     print('Response Status Code: ${response.statusCode}');
//     print('Response Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       setState(() {
//         pdfs = List<Map<String, dynamic>>.from(data['pdfs']);
//       });
//     } else {
//       // Handle error
//       print('Failed to load PDFs');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: pdfs.isEmpty
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : ListView.builder(
//         itemCount: pdfs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Document ${pdfs[index]['document_id']}'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PDFScreen(
//                     pdfPath: pdfs[index]['pdf_path'],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class PDFScreen extends StatefulWidget {
//   final String pdfPath;
//
//   PDFScreen({required this.pdfPath});
//
//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> {
//   bool _isLoading = true;
//   late PDFDocument document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }
//
//   loadDocument() async {
//     try {
//       // Convert local file path to URL
//       final pdfUrl = Uri.file(widget.pdfPath).toString();
//
//       // Encode the URL to handle spaces and special characters
//       final encodedUrl = Uri.encodeFull(pdfUrl);
//
//       document = await PDFDocument.fromURL(encodedUrl);
//
//       setState(() => _isLoading = false);
//     } catch (e) {
//       print('Error loading PDF: $e');
//       // Handle error loading PDF
//       setState(() => _isLoading = false);
//     }
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : PDFViewer(
//         document: document,
//         zoomSteps: 1,
//         // Add any other customization options here
//       ),
//     );
//   }
// }
