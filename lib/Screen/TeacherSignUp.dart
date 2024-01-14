
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelligent_white_board/utility.dart';

import '../Global.dart';
import '../Model/User.dart';
import 'login.dart';


class TeacherSignup extends StatefulWidget{
  final int userID; // Add this line

  TeacherSignup({required this.userID});


  @override
  State<TeacherSignup> createState() => _TeacherSignupState();
}

class _TeacherSignupState extends State<TeacherSignup> {
  bool _passwordObscured = true;

  String? __selectedLocation;



  var nametext = TextEditingController();

  var designationtext = TextEditingController();

  var phonetext = TextEditingController();

  var experiencetext= TextEditingController();


  Future<void> TeacherSignup(Teacher teacher) async {
    final apiUrl = Uri.parse('${Globals.ipAddress}/SignUpteacher');

    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(teacher.toJson()),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      // Registration successful
      utils.flushBarErrorMessage('SignUp Successful', context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              login(),
        ),
      );
      return;
    } else {
      // Registration failed
      utils.flushBarErrorMessage('Unsuccessful', context);
      final errorResponse = json.decode(response.body);
      print('Error message: ${errorResponse["message"]}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        height: 755,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icon/white.jpg'),
            fit: BoxFit.cover)
        ),


        child : Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor:Color(0xFFF5714C),
            title: Center(child: Text('Intelligent White Board', style: TextStyle(fontFamily: 'fontMAIN',),)),
          ),
          body: Padding(

            padding: const EdgeInsets.all(8.0),
            child:SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: 15,),
                    Container(
                      child:Text( "Welcome", style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFF5714C),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'fontMAIN',
                      ),
                      ),),

                    Padding(
                      padding: const EdgeInsets.only(top:60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 150,),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/icon/loginicon.png',
                            ),
                            backgroundColor: Colors.cyan.shade200,
                            radius: 20,
                          ),
                          Text(
                            " Teacher  SignUp ", style: TextStyle(fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'fontMAIN',
                            color: Color(0xFFF5714C),

                          ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 11,),
                    SizedBox(height: 14,),
                    TextField(
                        controller: nametext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Full Name',

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                                color: Colors.purple.shade200,
                                width: 3),

                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                  color: Colors.black

                              )

                          ),
                          prefixIcon: Icon(Icons.person, color: Color(0xFFF5714C),),

                        )

                    ),
                    SizedBox(height: 14,),
                    Container(height: 8,),
                    TextField(
                        controller: designationtext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical:2),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Designation",
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                                color: Color(0xFFF5714C),
                                width: 3),

                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                  color: Colors.black

                              )

                          ),
                          prefixIcon: Icon(Icons.email, color: Color(0xFFF5714C),),

                        )

                    ),
                   SizedBox(height: 14,),
                    Container(height: 8,),
                    TextField(
                        controller: phonetext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Phone No",
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                                color: Color(0xFFF5714C),
                                width: 3),

                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                  color: Colors.black

                              )

                          ),
                          prefixIcon: Icon(Icons.phone, color: Color(0xFFF5714C),),

                        )),


                    SizedBox(height: 14,),
                    Container(height: 8,),
                    TextField(
                        controller: experiencetext,

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Experience',
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                                color:Color(0xFFF5714C),
                                width: 3),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )

                          ),
                          prefixIcon: Icon(Icons.add_business, color: Color(0xFFF5714C),),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.plus_one_rounded,color: Color(0xFFF5714C),),
                            onPressed: (){

                            },

                          ),

                        )

                    ),

                    Container(height: 8,),



                    Container(height: 8,),

                    ElevatedButton(
                        onPressed: (){

                          String fullName = nametext.text.trim();

                          String phone = phonetext.text.trim();
                          String designation = designationtext.text.trim();
                          String experience = experiencetext.text.trim();

                          // Validate full name
                          if (fullName.isEmpty) {
                            utils.flushBarErrorMessage("Please enter your name", context);
                            return;
                          }


                          // Validate phone number
                          else if (!RegExp(r'^\d{11}$').hasMatch(phone)) {
                            utils.flushBarErrorMessage("Please enter a valid phone number", context);
                            return;
                          }

                          // Validate experience
                          else if (experience.isEmpty) {
                            utils.flushBarErrorMessage("Please enter your experience", context);
                            return;
                          }



                          print(fullName);
                          print(designation);
                          print(widget.userID);
                          print(experience);
                          print(phone);
                          final teacher = Teacher(
                            TeacherName: fullName,
                            PhoneNo: phone,
                            Designation: designation,
                            Experience: experience,
                            UserID: widget.userID, // Pass the userID from the widget
                          );

                          TeacherSignup(teacher);


                        },child: Text(
                        'SignUp',style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'fontMAIN'

                    )
                    ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF5714C)), // Change the button background color here
                      ),
                    ),

                  ]

              ),
            ),
          ),

        ));
  }
}




