import 'package:flutter/material.dart';
import 'package:intelligent_white_board/Screen/writing_pad.dart';

import '../Handler/testpdf.dart';

class HomeScreen extends StatefulWidget {
  final int id;
  HomeScreen({required this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedSubject = 'PF';
  String selectedLectureNo = 'Lecture_1_2';
  bool enableDropdowns = false; // Added to control enabling/disabling
  int selectedSection = 1; // Added to track selected section value

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: 900,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icon/white.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Column(
            children: [
              Text(
                "Intelligent White Board",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFF5714C),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'fontMAIN',
                ),
              ),
              // Space from the top
              Image.asset(
                "assets/icon/backimg.png",
                width: 150,
                height: 150,
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Pdfscreen(),
                            ),
                          );
                          setState(() {
                            enableDropdowns = true;
                          });
                        },
                        child: Image.asset(
                          'assets/icon/existing.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                      Text(
                        "Existing Docs",
                        style: TextStyle(
                          color: Color(0xFFF5714C),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle the click on the "New Docs" image
                          setState(() {
                            enableDropdowns = true;
                          });
                        },
                        child: Image.asset(
                          'assets/icon/new.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                      Text(
                        "New Docs",
                        style: TextStyle(
                          color: Color(0xFFF5714C),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedSubject,
                onChanged: enableDropdowns
                    ? (String? newValue) {
                  setState(() {
                    selectedSubject = newValue!;
                  });
                }
                    : null,
                items: <String>[
                  'PF',
                  'DSA',
                  'OPP',
                  'ECOM',
                  // Add more subjects as needed
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedLectureNo,
                onChanged: enableDropdowns
                    ? (String? newValue) {
                  setState(() {
                    selectedLectureNo = newValue!;
                  });
                }
                    : null,
                items: <String>[
                  'Lecture_1_2',
                  'Lecture_3_4',
                  'Lecture_5_6',
                  'Lecture_7_8',
                  'Lecture_9_10',
                  'Lecture_11_12',
                  'Lecture_13_14',
                  'Lecture_15_16',
                  // Add more lecture numbers as needed
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<int>(
                value: selectedSection,
                onChanged: enableDropdowns
                    ? (int? newValue) {
                  setState(() {
                    selectedSection = newValue!;
                  });
                }
                    : null,
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

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: enableDropdowns
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WritingPad(
                        selectedSubject: selectedSubject,
                        selectedLectureNo: selectedLectureNo,
                        selectedSection: selectedSection,
                        id:widget.id,
                      ),
                    ),
                  );
                }
                    : null,
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontFamily: 'fontMAIN',
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFF5714C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
