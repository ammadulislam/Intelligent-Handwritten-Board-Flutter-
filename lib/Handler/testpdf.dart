import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intelligent_white_board/Handler/pdfviewer.dart';

import '../Global.dart';

class Pdfscreen extends StatefulWidget {
  const Pdfscreen({Key? key}) : super(key: key);

  @override
  State<Pdfscreen> createState() => _PdfscreenState();
}

class _PdfscreenState extends State<Pdfscreen> {
  bool loading = true;
  late List pdflist;

  Future<void> fetchallpdf() async {

     final response = await http.get(Uri.parse("${Globals.ipAddress}/getPDFs"));

    if (response.statusCode == 200) {
      final dynamic decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey('pdfs') && decodedResponse['pdfs'] is List) {
        setState(() {
          pdflist = decodedResponse['pdfs'];
          loading = false;
        });
        print(pdflist);
      } else {
        print("Invalid response format: $decodedResponse");
      }
    } else {
      print("Failed to fetch PDFs. Status code: ${response.statusCode}");
    }
  }

  // Function to show a share dialog with a dropdown

  void _showShareDialog(String title) {
    int? selectedSection = 1; // Initial value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share $title'), // Customize the share message here
                SizedBox(height: 16.0),
                Text('Select Section:'),
                DropdownButton<int>(
                  value: selectedSection,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedSection = newValue!;
                    });
                  },
                  items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    String sectionName = '';
                    // Assign names based on section values
                    switch (value) {
                      case 1:
                        sectionName = 'BSIT-7A';
                        break;
                      case 2:
                        sectionName = 'BSIT-7B';
                        break;
                      case 3:
                        sectionName = 'BSCS-1A';
                        break;
                      case 4:
                        sectionName = 'BSCS-1B';
                        break;
                      case 5:
                        sectionName = 'BSSE-1A';
                        break;
                    }
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(sectionName),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logic to send selectedSection to the database
                // For example: _sendDataToDatabase(selectedSection);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    fetchallpdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF List"),
      ),
      body: Container(
        color: Colors.white,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: pdflist.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  leading: Image.asset(
                    'assets/icon/pdf.png',
                    width: 30.0,
                    height: 30.0,
                  ),
                  title: Text(pdflist[index]["Title"] ?? "Unknown Name"),
                  onTap: () {
                    String pdfPath = pdflist[index]["pdf_path"];
                    print("Pdf path $pdfPath");

                    pdfPath = pdfPath.replaceAll(r'\\', '/');
                    Uri pdfUri = Uri.parse(pdfPath);

                    // String pdfPath = pdflist[index]["pdf_path"];
                    // print("Pdf path $pdfPath");
                    // String serverUrl = "${Globals.ipAddress}";
                    //
                    // pdfPath = pdfPath.replaceAll(r'\\', '/');
                    // Uri pdfUri = Uri.parse(serverUrl).replace(path: pdfPath);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pdfviewer(urls: pdfUri.toString(), Title: pdflist[index]["Title"],
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Image.asset(
                      'assets/icon/share.png',
                      width: 38.0,
                      height: 38.0,
                    ),
                    onPressed: () {
                      _showShareDialog(pdflist[index]["Title"]);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
