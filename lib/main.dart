import'package:flutter/material.dart';

import 'Handler/Pdf.dart';
import 'Handler/testpdf.dart';
import 'Screen/Home.dart';
import 'Screen/StudentSignUp.dart';
import 'Screen/TeacherSignUp.dart';
import 'Screen/canvas2.dart';
import 'Screen/login.dart';
import 'Screen/userlogin.dart';
import 'Screen/writing_pad.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 245, 113, 76), // Set the background color to #F5714CFF
      ),
     // title: 'Intelligent White Board',4
      //home:StudentSignup(userID: 1,),
      //home:TeacherSignup(userID: 1,),
       // home:login_forms(),
        //home:WritingPad(),
       //home:login(),
          home:HomeScreen(id: 12,),
       //home:Pdfscreen(),
       //home: Canvas2(),
    );
  }
}

