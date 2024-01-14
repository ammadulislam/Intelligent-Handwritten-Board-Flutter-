import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

class Pdfviewer extends StatefulWidget {
 final String urls;
 final String Title;
 Pdfviewer({required this.urls, required this.Title});

  @override
  State<Pdfviewer> createState() => _PdfviewerState();
}

class _PdfviewerState extends State<Pdfviewer> {
  bool loading=true;
  late PDFDocument pdfDocument;


  loadpdf() async {
    try {

      pdfDocument = await PDFDocument.fromURL('${Globals.ipAddress}/getpdfss?path=${widget.urls}');
      //pdfDocument = await PDFDocument.fromURL(widget.urls);
      //pdfDocument = await PDFDocument.fromURL("http://192.168.194.40:5000/pdf/${widget.urls}");


      setState(() {
        loading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle the error (e.g., show an error message)
    }
  }


  @override
  void initState() {
    super.initState();
    print("##########################${widget.urls}");
    pdfDocument = PDFDocument(); // Initialize here or in the declaration
    loadpdf();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.Title),),
     // body:PDFViewer(document: pdfDocument)

      body:loading
          ? Center(child: CircularProgressIndicator(),):PDFViewer(document: pdfDocument)
    );
  }
}
