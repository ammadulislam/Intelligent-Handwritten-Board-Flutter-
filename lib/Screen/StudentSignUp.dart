
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intelligent_white_board/utility.dart';
import 'package:http/http.dart' as http;

import '../Global.dart';
import 'login.dart';

class StudentSignup extends StatefulWidget{
  final int userID; // Add this line

  StudentSignup({required this.userID});
  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  late int numericalValue;
  bool _passwordObscured = true;

  int _selectedSection = 1;
  final Map<String, int> sectionToValue = {
    'BSIT-7A': 1,
    'BSIT-7B': 2,
    'BSCS-1A': 3,
    'BSCS-1B': 4,
    'BSSE-1A': 5,
  }; // Default value '1'



  var nametext = TextEditingController();

  var regtext = TextEditingController();

  var disciplinetext = TextEditingController();

  var Sectiontext= TextEditingController();

  Future<void> Studentsignup(String name, String registration, String discipline, int section, int userID,) async {
   // final apiUrl = Uri.parse('${Globals.ipAddress}/Signupstudent'); // Replace with your API endpoint
     final apiUrl=Uri.parse('${Globals.ipAddress}/Signupstudent');
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'StudentName': name,
        'RegistrationNo': registration,
        'Discipline': discipline,
        'SectionID': section,
        'UserID': userID,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      // Registration successful
      utils.flushBarErrorMessage('SignUp Successful',context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              login(),
        ),
      );


      return;// You can add any desired behavior here
    } else {
      // Registration failed
      utils.flushBarErrorMessage('Unsuccssful',context);
      final errorResponse = json.decode(response.body);
      print('Error message: ${errorResponse["message"]}');
      //return; // You can add error handling logic here
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
            backgroundColor: Color(0xFFF5714C),
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
                        color:Color(0xFFF5714C),
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
                            " Student SignUp ", style: TextStyle(fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'fontMAIN',
                            color: Color(0xFFF5714C),

                          ),
                          ),
                        ],
                      ),
                    ),



                    Container(height: 11,),
                    TextField(
                        controller: nametext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Your Name',
                          labelText: 'Name',
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
                          prefixIcon: Icon(Icons.person, color: Color(0xFFF5714C),),

                        )

                    ),
                     SizedBox(height: 14,),
                    Container(height: 8,),
                    TextField(
                        controller: regtext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical:2),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Registration No",
                          labelText: 'Registration',
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
                          prefixIcon: Icon(Icons.email, color:Color(0xFFF5714C),),

                        )

                    ),
                    SizedBox(height: 14,),
                    Container(height: 8,),
                    TextField(
                        controller: disciplinetext,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Discipline",
                          labelText: 'Discipline',
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
                          prefixIcon: Icon(Icons.class_, color: Color(0xFFF5714C),),

                        )),
                    Container(height: 8,),
                    SizedBox(height: 14,),
                    Container(
                      width: 600,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                     child: DropdownButton<int>(
                       hint: Padding(
                         padding: const EdgeInsets.all(8.40),
                         child: Text("Select Your Section", style: TextStyle(fontSize: 15, color: Colors.black54)),
                       ),
                       value: _selectedSection,
                       icon: Padding(
                         padding: const EdgeInsets.all(12.0),
                         child: Icon(Icons.arrow_drop_down, color: Color(0xFFF5714C)),
                       ),
                       iconSize: 25,
                       elevation: 16,
                       isExpanded: true,
                       style: TextStyle(color: Colors.black54),
                       onChanged: (int? newValue) {
                         setState(() {
                           _selectedSection = newValue ?? 1; // Set the selected section directly as an integer
                           // Now, you can save the corresponding numerical value to the database
                         });
                       },
                       items: sectionToValue.keys.map<DropdownMenuItem<int>>((String value) {
                         return DropdownMenuItem<int>(
                           value: sectionToValue[value]!,
                           child: Padding(
                             padding: const EdgeInsets.all(12.0),
                             child: Text(value, style: TextStyle(fontSize: 15)),
                           ),
                         );
                       }).toList(),
                     ),
                    ),

                    Container(height: 8,),
                    SizedBox(height: 14,),
                    ElevatedButton(
                        onPressed: () async {

                          String fullName = nametext.text.trim();

                          String reg = regtext.text.trim();
                          String discipline = disciplinetext.text.trim();


                          // Validate full name
                          if (fullName.isEmpty) {
                            utils.flushBarErrorMessage("Please enter your name", context);
                            return;
                          }


                          // Validate experience
                          else if (reg.isEmpty) {
                            utils.flushBarErrorMessage("Please enter your Registration No", context);
                            return;
                          }
                          else if (!RegExp(r'^\d{4}-[a-zA-Z]+-\d{4}$').hasMatch(reg)) {
                            utils.flushBarErrorMessage("Please enter a valid registration number (e.g., 2020-arid-0184)", context);

                         return; }
                          else if (discipline.isEmpty) {
                            utils.flushBarErrorMessage("Please enter your descipline ", context);
                          return;
                          }
                          else if (_selectedSection == null) {
                            utils.flushBarErrorMessage("Please select a section", context);
                          return;
                          }

                          try {
                            await Studentsignup(fullName, reg, discipline, _selectedSection!, widget.userID);
                            print("######################## $numericalValue");
                            print("......................................");
                            print("API Request Completed Successfully");
                          } catch (e) {
                            print("API Request Failed: $e");
                          }
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




