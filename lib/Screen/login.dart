import 'package:flutter/material.dart';
import 'package:intelligent_white_board/Screen/userlogin.dart';
import 'dart:convert';
import 'package:intelligent_white_board/utility.dart';
import 'package:http/http.dart' as http;

import '../Global.dart';
import '../Model/User.dart';
import '../welcom.dart';
import '../welcometeacher.dart';
import 'Home.dart';
import 'TeacherSignUp.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool _passwordObscured = true;
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  var emailtext = TextEditingController();
  var passwordtext = TextEditingController();

  Future<http.Response> Login(String email, String password) async {
    final apiUrl = Uri.parse('${Globals.ipAddress}/login');

    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Email': email,
        'Password': password,
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
          backgroundColor: Color(0xFFF5714C), // Change the app bar color here
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
          padding: const EdgeInsets.all(8.0,
          ),
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
                  padding: const EdgeInsets.only(top: 30),
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
                        backgroundColor: Colors.cyan.shade200,
                        radius: 20,
                      ),
                      Text(
                        " Login ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'fontMAIN',
                          color: Color(0xFFF5714C), // Change the text color here
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
                            color: Color(0xFFF5714C), // Change the border color here
                            width: 3,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide(
                            color: Color(0xFFF5714C), // Change the border color here
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFFF5714C), // Change the icon color here
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
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
                            color: Color(0xFFF5714C), // Change the border color here
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
                          color: Color(0xFFF5714C), // Change the icon color here
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                            color: Color(0xFFF5714C), // Change the icon color here
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
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => forgotpassword(),
                        // ));
                      },
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
                    print("-------------------->CHECK__________________");
                    String email = emailtext.text;
                    String password = passwordtext.text;

                    if (emailtext.text.isEmpty) {
                      utils.flushBarErrorMessage("Please Enter Your Email", context);
                    } else if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$', caseSensitive: false).hasMatch(email)) {
                      utils.flushBarErrorMessage("Please enter a valid email address", context);
                    } else if (passwordtext.text.isEmpty) {
                      utils.flushBarErrorMessage("Please Enter Your Password", context);
                    } else if (password.length < 8) {
                      utils.flushBarErrorMessage("Password must be at least 8 characters long", context);
                    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(password)) {
                      utils.flushBarErrorMessage("Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~)", context);
                    }
                    // Make the API request to the Flask endpoint
                    final response = await Login(email, password);

                    if (response.statusCode == 200) {
                      final userData = User.fromJson(json.decode(response.body));
                      print(userData.Role);
                      if (userData.Role == 'Teacher') {
                        int id=userData.UserID;
                        print(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomeScreen(id: id),
                        ));
                      } else if (userData.Role == 'Student') {
                        int id=userData.UserID;
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomeScreen(id: id),
                        ));
                      }
                    } else {
                      print("Invalid");
                      final errorMessage = json.decode(response.body)['message'];
                      utils.flushBarErrorMessage(errorMessage, context);
                      final errorResponse = json.decode(response.body);
                      print('Error message: ${errorResponse["message"]}');
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'fontMAIN',
                      color: Colors.white, // Change the button text color here
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF5714C)), // Change the button background color here
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => login_forms(),
                      ),
                    );
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontFamily: 'fontMAIN',
                      color: Color(0xFFF5714C), // Change the text color here
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
