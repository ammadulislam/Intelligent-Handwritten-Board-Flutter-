import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intelligent_white_board/utility.dart';
import 'package:http/http.dart' as http;

import '../Global.dart';
import 'StudentSignUp.dart';
import 'TeacherSignUp.dart';

class login_forms extends StatefulWidget {
  @override
  State<login_forms> createState() => _login_formsState();
}

class _login_formsState extends State<login_forms> {
  bool _passwordObscured = true;
  var emailtext = TextEditingController();
  var passwordtext = TextEditingController();
  var confirmPasswordtext = TextEditingController();
  String selectedRole = 'Student'; // Default to 'Student'

  Future<http.Response> Signup(
      String email,
      String password,
      String role,
      ) async {
    final apiUrl =
    Uri.parse('${Globals.ipAddress}/signup'); // Replace with your API endpoint for user registration

    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Email': email, // Update 'Username' to match your API's expected field name
        'Password': password,
        'Role': role,
      }),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 755,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icon/white.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5714C),
          title: Center(
            child: Text(
              'Intelligent White Board',
              style: TextStyle(
                fontFamily: 'fontMAIN',
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                ),
                Container(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFF5714C),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'fontMAIN',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/icon/loginicon.png',
                        ),
                        backgroundColor:Color(0xFFF5714C),
                        radius: 20,
                      ),
                      Text(
                        "New User SignUp ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'fontMAIN',
                          color: Color(0xFFF5714C),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 11,
                    ),
                    TextField(
                      controller: emailtext,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Email",
                        labelText: 'Email',
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color:Color(0xFFF5714C),
                            width: 3,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color:Color(0xFFF5714C),
                        ),
                      ),
                    ),
                    Container(height: 4),
                    // Radio buttons for role selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Select Role:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Column(

                          children: [

                            RadioListTile(
                              title: Text('Student'),
                              value: 'Student',
                              groupValue: selectedRole,
                              onChanged: (String? value) {
                                if (value == null) return;
                                setState(() {
                                  selectedRole = value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text('Teacher'),
                              value: 'Teacher',
                              groupValue: selectedRole,
                              onChanged: (String? value) {
                                if (value == null) return;
                                setState(() {
                                  selectedRole = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Column(
                  children: [
                    Container(
                      height: 11,
                    ),
                    TextField(
                      controller: passwordtext,
                      obscureText: _passwordObscured,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color:Color(0xFFF5714C),
                            width: 3,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color:Color(0xFFF5714C),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFF5714C),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordObscured = !_passwordObscured;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 8,
                    ),
                    TextField(
                      controller: confirmPasswordtext,
                      obscureText: _passwordObscured,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Confirm Password',
                        labelText: 'Confrim Password',
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color: Color(0xFFF5714C),
                            width: 3,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color:Color(0xFFF5714C),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFF5714C),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordObscured = !_passwordObscured;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'fontMAIN',
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    String email = emailtext.text;
                    String password = passwordtext.text;
                    String confirmPassword = confirmPasswordtext.text;

                    if (emailtext.text.isEmpty) {
                      utils.flushBarErrorMessage(
                          "Please Enter Your Email", context);
                      return;
                    } else if (!RegExp(
                        r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(email)) {
                      utils.flushBarErrorMessage(
                          "Please enter a valid email address", context);
                      return;
                    } else if (passwordtext.text.isEmpty) {
                      utils.flushBarErrorMessage(
                          "Please Enter Your Password", context);
                      return;
                    } else if (password.length < 8) {
                      utils.flushBarErrorMessage(
                          "Password must be at least 8 characters long",
                          context);
                      return;
                    } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(password)) {
                      utils.flushBarErrorMessage(
                          "Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~)",
                          context);
                    } else if (confirmPassword.isEmpty) {
                      utils.flushBarErrorMessage(
                          "Please confirm your password", context);
                      return;
                    } else if (password != confirmPassword) {
                      utils.flushBarErrorMessage(
                          "Passwords do not match", context);
                    } else {
                      final response =await Signup(email, password, selectedRole); // Call the API function

                      if (response.statusCode == 201) {
                        // Registration successful, retrieve UserID from response
                        final responseData = jsonDecode(response.body);
                        int userID = responseData["UserID"];

                        if (selectedRole == "Teacher") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TeacherSignup(userID: userID),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentSignup(userID: userID),
                            ),
                          );
                        }
                      } else {
                        // Handle registration error
                        final errorMessage =
                        jsonDecode(response.body)['Not Inserted'];
                        utils.flushBarErrorMessage(errorMessage, context);
                        final errorResponse = json.decode(response.body);
                        print('Error message: ${errorResponse["message"]}');
                      }
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'fontMAIN',
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF5714C)), // Change the button background color here
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }
}
