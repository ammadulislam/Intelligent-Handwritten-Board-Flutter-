// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
//
// class DBHandler {
//   static Future<void> sendImagesToApi(List<Uint8List> images) async {
//
//     String apiUrl = 'https://192.168.0.125:5000/upload';
//
//
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//       for (var i = 0; i < images.length; i++) {
//         var image = images[i];
//         var multipartFile = http.MultipartFile.fromBytes('images', image, filename: 'image_$i.jpg');
//         request.files.add(multipartFile);
//       }
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         print('Images uploaded successfully');
//         // Handle success if needed
//       } else {
//         print('Failed to upload images');
//         // Handle failure if needed
//       }
//     } catch (e) {
//       print('Error: $e');
//       // Handle error if needed
//     }
//   }
// }
//
//
//
// /////////////////////////Flask Api
// from flask import Flask, jsonify, request
// from PIL import Image as PILImage
//
// from datetime import datetime as dt
// import base64
//
// from reportlab.lib.pagesizes import letter
//
// from reportlab.platypus import SimpleDocTemplate, Image
// import os
// import datetime
//
// app = Flask(__name__)
// def get_current_time():
// return datetime.datetime.now()
//
//
//
//
// import pyodbc
//
// server = 'DESKTOP-TJRF2CO'
// database = 'FYPDatabase'
// username = 'sa'
// password = '123'
//
// def connect_to_database():
// connection_string = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}"
// return pyodbc.connect(connection_string)
//
// try:
// # Attempt to establish a connection
// connection = connect_to_database()
// print("Connection to SQL Server successful")
// connection.close()
// except Exception as e:
// print(f"Error: {str(e)}")
//
//
// #//////////////////////////////////////////////////////////////////////////Save Image
//
//
//
// # Set the upload folder path (change it to your desired path)
// UPLOAD_FOLDER = "C:/Users/HP/PycharmProjects/FYP_Project/path_to_upload_folder"
// app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
//
// ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif'}
//
//
// def allowed_file(filename):
// return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
//
//
// def resize_image(image_path, max_width, max_height):
// img = PILImage.open(image_path)
//
// if img.mode == 'RGBA':
// img = img.convert('RGB')
//
// img.thumbnail((max_width, max_height))
// img.save(image_path, 'JPEG')
//
//
//
//
// @app.route('/addDocument', methods=['POST'])
// def addDocument():
// try:
// data = request.json
// teacher_id = data.get("TeacherID")
// section_id = data.get("SectionID")
// title = data.get("Title")
// course = data.get("Course")
// images = data.get("Images")  # List of base64-encoded image strings
//
// print("Received data:", teacher_id, section_id, title, course)
//
// if not all([teacher_id, section_id, title, course, images]):
// return jsonify({"error": "Missing required data"}), 400
//
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT TeacherID FROM Teacher WHERE TeacherID = ?", (teacher_id,))
// if cursor.fetchone() is None:
// connection.close()
// return jsonify({"error": "Invalid TeacherID"}), 400
//
// cursor.execute("SELECT SectionID FROM Section WHERE SectionID = ?", (section_id,))
// if cursor.fetchone() is None:
// connection.close()
// return jsonify({"error": "Invalid SectionID"}), 400
//
// current_date = datetime.datetime.now().date()
//
// cursor.execute("INSERT INTO Document (TeacherID, SectionID, Title, Date, Course) VALUES (?, ?, ?, ?, ?)",
// (teacher_id, section_id, title, current_date, course))
// connection.commit()
//
// cursor.execute("SELECT @@IDENTITY")
// document_id = cursor.fetchone()[0]
//
//
// document_image_dir = os.path.join(app.config['UPLOAD_FOLDER'], str(document_id))
// os.makedirs(document_image_dir, exist_ok=True)
//
// for sequence, base64_image in enumerate(images, start=1):
// image_bytes = base64.b64decode(base64_image)
// filename = f"image_{sequence}.jpg"
// image_path = os.path.join(document_image_dir, filename)
// with open(image_path, "wb") as image_file:
// image_file.write(image_bytes)
//
// max_width = 456.0
// max_height = 636.0
// resize_image(image_path, max_width, max_height)
// cursor.execute("INSERT INTO Image (DocumentID, ImagePath, Sequence) VALUES (?, ?, ?)",
// (document_id, image_path, sequence))
// # cursor.execute("SELECT @@IDENTITY")
// # document_id = cursor.fetchone()[0]
//
//
//
// pdf_filename = os.path.join(app.config['UPLOAD_FOLDER'], f"document_{document_id}.pdf")
// doc = SimpleDocTemplate(pdf_filename, pagesize=letter)
//
// story = []
// image_paths = []
//
// cursor.execute("SELECT ImagePath FROM Image WHERE DocumentID = ? ORDER BY Sequence", (document_id,))
// image_paths = [row[0] for row in cursor.fetchall()]
//
// for image_path in image_paths:
// img = PILImage.open(image_path)
// img_width, img_height = img.size
//
// # Initialize new_width and new_height
// new_width = img_width
// new_height = img_height
//
// # Resize the image to fit within the specified dimensions
// max_width = 456.0
// max_height = 636.0
// if img_width > max_width or img_height > max_height:
// aspect_ratio = img_height / float(img_width)
// new_width = max_width
// new_height = int(max_width * aspect_ratio)
// img = img.resize((new_width, new_height), PILImage.ANTIALIAS)
//
// # Add the resized image to the PDF
// image = Image(image_path, width=new_width, height=new_height)
// story.append(image)
//
// doc.build(story)
//
// cursor.execute("UPDATE Document SET DocumentPath = ? WHERE DocumentID = ?",
// (pdf_filename, document_id))
// connection.commit()
//
// connection.close()
//
// return jsonify({"message": "Document and PDF created successfully", "pdf_path": pdf_filename})
//
// except Exception as e:
// print('Error:', str(e))
// return jsonify({"error": "An error occurred while processing your request"}), 500

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// #                                                                                                                        login
//
// @app.route('/login', methods=['POST'])
// def login():
// data = request.json
//
// if not data or 'Email' not in data or 'Password' not in data:
// return jsonify({"error": "Invalid login data"}), 400
//
// email = data['Email']
// password = data['Password']
//
// # Retrieve user data from the database based on the provided username
// connection = connect_to_database()
// cursor = connection.cursor()
//
// try:
// cursor.execute("SELECT UserID, Password, Role FROM Users WHERE Email = ?", (email,))
// user_data = cursor.fetchone()
//
// if user_data is None:
// return jsonify({"error": "User not found"}), 404
//
// stored_password = user_data[1]  # Index 1 corresponds to the 'Password' column
// user_role = user_data[2]  # Index 2 corresponds to the 'Role' column
// user_id = user_data[0]  # Index 0 corresponds to the 'UserID' column
//
// if password == stored_password:
// return jsonify({"message": "Login successful", "Role": user_role, "UserID": user_id}), 200
// else:
// return jsonify({"error": "Invalid password"}), 401
// except Exception as e:
// return jsonify({"error": str(e)}), 500
// finally:
// connection.close()
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// #                                                                                                     Signup
//
//
// # A list to store user data as dictionaries
// users = []
// @app.route('/signup', methods=['POST'])
// def signup():
// data = request.json
//
// if not data or 'Email' not in data or 'Password' not in data or 'Role' not in data:
// return jsonify({"message": "Invalid request data"}), 400
//
// email = data['Email']
// password = data['Password']
// role = data['Role']
//
//
//
// print("Received data:", username, password, role)  # Add this line for debugging
//
//
//
// # Check if the user already exists
// for user in users:
// if user['Username'] == username:
// return jsonify({"message": "User already exists"}), 400
//
// # Create a connection
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Execute SQL to insert user data
// cursor.execute("INSERT INTO Users (Email, Password, Role) VALUES (?, ?, ?)",
// (email, password, role))
//
// # Commit changes and close the connection
// connection.commit()
// connection.close()
//
// # Retrieve the UserID of the newly registered user
// connection = connect_to_database()
// cursor = connection.cursor()
// cursor.execute("SELECT UserID FROM Users WHERE Email = ?", (email,))
// user_id = cursor.fetchone()[0]  # Get the UserID
//
// return jsonify({"message": "User registered successfully", "UserID": user_id}), 201
//
// #------------------------------------------------------------------------------------------------------------------------StudentSignUp
//
// @app.route('/Signupstudent', methods=['POST'])
// def Signupstudent():
// data = request.json
//
// if not data or 'UserID' not in data or 'RegistrationNo' not in data or 'StudentName' not in data or 'Discipline' not in data or 'SectionID' not in data:
// error_response = {
// "message": "Invalid request data",
// "details": "Required fields are missing"
// }
// return jsonify({"message": "Invalid request data"}), 400
//
// user_id = data['UserID']
// registration_no = data['RegistrationNo']
// student_name = data['StudentName']
// discipline = data['Discipline']
// section_id = data['SectionID']
//
// print("Received data:", user_id, registration_no, student_name,discipline,section_id)
//
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Check if the user and section exist before adding the student
// cursor.execute("SELECT UserID FROM Users WHERE UserID = ?", (user_id,))
// user_result = cursor.fetchone()
// if user_result is None:
// return jsonify({"message": "User with specified UserID does not exist"}), 400
//
// cursor.execute("SELECT SectionID FROM Section WHERE SectionID = ?", (section_id,))
// section_result = cursor.fetchone()
// if section_result is None:
// return jsonify({"message": "Section with specified SectionID does not exist"}), 400
//
// cursor.execute("INSERT INTO Student (UserID, RegistrationNo, StudentName, Discipline, SectionID) VALUES (?, ?, ?, ?, ?)",
// (user_id, registration_no, student_name, discipline, section_id))
//
// connection.commit()
// connection.close()
//
// return jsonify({"message": "Student added successfully"}), 201
//
//
// #-------------------------------------------------------------------------------------------------------------TeacherSignUp
//
// @app.route('/SignUpteacher', methods=['POST'])
// def SignUpteacher():
// data = request.json
//
// if not data or 'UserID' not in data or 'TeacherName' not in data or 'Designation' not in data or 'PhoneNo' not in data or 'Experience' not in data:
// error_response = {
// "message": "Invalid request data",
// "details": "Required fields are missing"
// }
// return jsonify(error_response), 400
//
// user_id = data['UserID']
// teacher_name = data['TeacherName']
// designation = data['Designation']
// phone_no = data['PhoneNo']
// experience = data['Experience']
//
// # Create a connection
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Check if the provided UserID exists in the User table
// cursor.execute("SELECT COUNT(*) FROM Users WHERE UserID = ?", (user_id,))
// user_count = cursor.fetchone()[0]
//
// if user_count == 0:
// error_response = {
// "message": "User with provided UserID does not exist",
// "details": f"UserID {user_id} does not exist"
// }
// return jsonify(error_response), 400
//
// # Insert the teacher data into the Teacher table
// cursor.execute("INSERT INTO Teacher (UserID, TeacherName, Designation, PhoneNo, Experience) VALUES (?, ?, ?, ?, ?)",
// (user_id, teacher_name, designation, phone_no, experience))
//
// # Commit changes and close the connection
// connection.commit()
// connection.close()
//
// return jsonify({"message": "Teacher added successfully"}), 201
//
//
//
//
//
//
//
//
//
//
// @app.route('/Getsignup', methods=['GET'])
// def Getsignup():
// # Create a connection
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Execute SQL to retrieve user signup data
// cursor.execute("SELECT * from Users")
//
// # Fetch all rows from the result
// user_data = cursor.fetchall()
//
// # Close the connection
// connection.close()
//
// # Convert the result to a list of dictionaries
// user_list = []
// for row in user_data:
// user_dict = {
// "UserID":row.UserID,
// "Username": row.Username,
// "Password": row.Password,
// "Role": row.Role
// }
// user_list.append(user_dict)
//
// return jsonify(user_list)
//
// #                                                       get_teachers
//
// @app.route('/get_teachers', methods=['GET'])
// def get_teachers():
// # Create a connection
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Execute SQL to retrieve teacher data
// cursor.execute("SELECT TeacherID, UserID, TeacherName, Designation FROM Teacher")
//
// # Fetch all rows from the result
// teacher_data = cursor.fetchall()
//
// # Close the connection
// connection.close()
//
// # Convert the result to a list of dictionaries
// teacher_list = []
// for row in teacher_data:
// teacher_dict = {
// "TeacherID": row.TeacherID,
// "UserID": row.UserID,
// "TeacherName": row.TeacherName,
// "Designation": row.Designation
// }
// teacher_list.append(teacher_dict)
//
// return jsonify(teacher_list)
//
// #                                                                          SignUpteacher
//
//
//
//
//
// #                                                                          get_students
//
//
// @app.route('/get_students', methods=['GET'])
// def get_students():
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT StudentID, UserID, RegistrationNo, StudentName, Discipline, SectionID FROM Student")
// student_data = cursor.fetchall()
//
// students_list = []
// for student in student_data:
// student_dict = {
// "StudentID": student.StudentID,
// "UserID": student.UserID,
// "RegistrationNo": student.RegistrationNo,
// "StudentName": student.StudentName,
// "Discipline": student.Discipline,
// "SectionID": student.SectionID
// }
// students_list.append(student_dict)
//
// connection.close()
//
// return jsonify(students_list)
//
//
// #                                                                                   Signupstudent
//
//
//
//
//
// #                                                                          StartSession
//
//
// def teacher_exists(teacher_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT TeacherID FROM Teacher WHERE TeacherID = ?", (teacher_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result is not None
//
// except Exception as e:
// return False
//
//
// def section_exists(section_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT SectionID FROM Section WHERE SectionID = ?", (section_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result is not None
//
// except Exception as e:
// return False
//
//
// @app.route('/StartSession', methods=['POST'])
// def StartSession():
// try:
// data = request.json
//
// if not data or 'TeacherID' not in data or 'SectionID' not in data:
// return jsonify({"message": "Invalid session data"}), 400
//
// teacher_id = data['TeacherID']
// section_id = data['SectionID']
//
// if not teacher_exists(teacher_id):
// return jsonify({"error": "Invalid TeacherID"}), 400
//
// if not section_exists(section_id):
// return jsonify({"error": "Invalid SectionID"}), 400
//
// current_time = dt.now()
//
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("INSERT INTO Session (TeacherID, SectionID, StartTime) VALUES (?, ?, ?)",
// (teacher_id, section_id, current_time))
//
// connection.commit()
// connection.close()
//
// return jsonify({"message": "Session added successfully"}), 201
//
// except Exception as e:
// return jsonify({"error": str(e)})
//
//
//
//
//
// #                                                                                      end_session time save
//
//
//
//
//
// @app.route('/end_session/<int:session_id>', methods=['POST'])
// def end_session(session_id):
// # Check if the session exists
// connection = connect_to_database()
// cursor = connection.cursor()
// cursor.execute("SELECT * FROM Session WHERE SessionID=?", (session_id,))
// session_data = cursor.fetchone()
//
// if session_data is None:
// return jsonify({"message": "Session not found"}), 404
//
// # Get the current system time
// current_time = get_current_time()
//
// # Update the session with the end time
// cursor.execute("UPDATE Session SET EndTime=? WHERE SessionID=?", (current_time, session_id))
// connection.commit()
// connection.close()
//
// return jsonify({"message": "Session ended successfully"}), 200
//
//
// # #--------------------------------------------------------------------------------------------------getImage
// #
// # @app.route('/getImage')
// # def getImage():
// #     # Replace the following lines with your actual data retrieval code using pyodbc
// #     connection = connect_to_database()
// #     cursor = connection.cursor()
// #
// #     cursor.execute("SELECT ImageID, DocumentID, ImagePath, Sequence FROM image")
// #     image_data = cursor.fetchall()
// #     connection.close()
// #
// #     data_list = []
// #     for image in image_data:
// #         data_dict = {
// #             "ImageID": image.ImageID,
// #             "DocumentID": image.DocumentID,
// #             "ImagePath": image.ImagePath,
// #             "Sequence": image.Sequence,
// #             # Add other columns as needed
// #         }
// #         data_list.append(data_dict)
// #
// #     return jsonify(data_list)
// #
// #
// # #--------------------------------------------------------------------------------------------------imagePost
// #
// #
// # @app.route('/addImage', methods=['POST'])
// # def addimage():
// #
// #
// #
// #     def get_document_ids():
// #         try:
// #             connection = connect_to_database()
// #             cursor = connection.cursor()
// #
// #             cursor.execute("SELECT DocumentID FROM Document")
// #             document_ids = [row.DocumentID for row in cursor.fetchall()]
// #
// #             connection.close()
// #             return document_ids
// #
// #         except Exception as e:
// #             return []
// #
// #
// #
// #     try:
// #         data = request.json
// #         document_id = data.get("DocumentID")
// #         image_path = data.get("ImagePath")
// #         sequence = data.get("Sequence")
// #
// #         if not document_id or not image_path or sequence is None:
// #             return jsonify({"error": "Missing required data"}), 400
// #
// #
// #
// #         document_ids = get_document_ids()
// #         if document_id not in document_ids:
// #             return jsonify({"error": "Invalid DocumentID"}), 400
// #
// #
// #         connection = connect_to_database()
// #         cursor = connection.cursor()
// #
// #         # Assuming 'image' table has columns: DocumentID, ImagePath, Sequence
// #         cursor.execute("INSERT INTO image (DocumentID, ImagePath, Sequence) VALUES (?, ?, ?)",
// #                        (document_id, image_path, sequence))
// #         connection.commit()
// #         connection.close()
// #
// #         return jsonify({"message": "Image added successfully"})
// #
// #     except Exception as e:
// #         return jsonify({"error": str(e)})
//
//
// #-------------------------------------------------------------------------------------------getCurrentActiveSession
//
// def student_exists(student_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT StudentID FROM Student WHERE StudentID = ?", (student_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result is not None
//
// except Exception as e:
// return False
//
// def get_section_id_for_student(student_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT SectionID FROM Student WHERE StudentID = ?", (student_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result[0] if result else None
//
// except Exception as e:
// return None
//
// def get_current_active_session(section_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT SessionID FROM Session WHERE SectionID = ? AND EndTime IS NULL", (section_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result[0] if result else None
//
// except Exception as e:
// return None
//
// @app.route('/joinCurrentActiveSession', methods=['POST'])
// def join_current_active_session():
// try:
// data = request.json
// student_id = data.get("StudentID")
//
// if not student_id:
// return jsonify({"error": "Missing required data"}), 400
//
// if not student_exists(student_id):
// return jsonify({"error": "Invalid StudentID"}), 400
//
// section_id = get_section_id_for_student(student_id)
//
// if not section_id:
// return jsonify({"error": "Student is not associated with any section"}), 400
//
// session_id = get_current_active_session(section_id)
//
// if not session_id:
// return jsonify({"error": "No active session for this student's section"}), 400
//
// # Implement your logic to allow the student to join the ongoing session
//
// return jsonify({"message": "Student can join the ongoing session"})
//
// except Exception as e:
// return jsonify({"error": str(e)})
//
//
//
//
//
// #---------------------------------------------------------------------------------------JoinSessionPost
//
//
//
//
//
//
// def student_exists(student_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT StudentID FROM Student WHERE StudentID = ?", (student_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result is not None
//
// except Exception as e:
// return False
//
//
// def session_exists(session_id):
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT SessionID FROM Session WHERE SessionID = ?", (session_id,))
// result = cursor.fetchone()
//
// connection.close()
// return result is not None
//
// except Exception as e:
// return False
//
//
// @app.route('/joinSession', methods=['POST'])
// def joinSession():
// try:
// data = request.json
// student_id = data.get("StudentID")
// session_id = data.get("SessionID")
//
// if not student_id or not session_id:
// return jsonify({"error": "Missing required data"}), 400
//
// if not student_exists(student_id):
// return jsonify({"error": "Invalid StudentID"}), 400
//
// if not session_exists(session_id):
// return jsonify({"error": "Invalid SessionID"}), 400
//
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// # Check if session is active (EndTime is NULL)
// cursor.execute("SELECT EndTime, SectionID FROM Session WHERE SessionID = ? AND EndTime IS NULL", (session_id,))
// active_session = cursor.fetchone()
//
// if not active_session:
// return jsonify({"error": "Session is no longer active"}), 400
//
// session_section_id = active_session[1]  # Extract the SectionID associated with the session
//
// # Get the SectionID of the student
// cursor.execute("SELECT SectionID FROM Student WHERE StudentID = ?", (student_id,))
// student_section_id = cursor.fetchone()[0]
//
// if session_section_id != student_section_id:
// return jsonify({"error": "Student's section does not match the session's section"}), 400
//
// current_time = dt.now()
//
// # Insert into JoinSession table
// cursor.execute("INSERT INTO JoinSession (StudentID, SessionID, Time) VALUES (?, ?, ?)",
// (student_id, session_id, current_time))
// connection.commit()
//
// connection.close()
//
// return jsonify({"message": "Student joined the session"})
//
// except Exception as e:
// return jsonify({"error": str(e)}), 500
//
// except Exception as e:
// return jsonify({"error": str(e)})
//
//
//
// #-------------------------------------------------------------------------Get Joined Student
// @app.route('/getJoinSessions', methods=['GET'])
// def get_join_sessions():
// try:
// connection = connect_to_database()
// cursor = connection.cursor()
//
// cursor.execute("SELECT JoinID, StudentID, SessionID, Time FROM JoinSession")
// join_sessions = cursor.fetchall()
//
// connection.close()
//
// data_list = []
// for join_session in join_sessions:
// data_dict = {
// "JoinID": join_session.JoinID,
// "StudentID": join_session.StudentID,
// "SessionID": join_session.SessionID,
// "Time": join_session.Time
// }
// data_list.append(data_dict)
//
// return jsonify(data_list)
//
// except Exception as e:
// return jsonify({"error": str(e)})
//
//
//
//
//
// # def check_credentials(email, password):
// #     cursor = conn.cursor();
// #     query = "SELECT * FROM [User] WHERE email=? AND password=?"
// #     cursor.execute(query, (email, password))
// #     return cursor.fetchone() is not None
// #
// #
// # @app.route('/login', methods=['POST'])
// # def login():
// #     if 'email' not in request.form or 'password' not in request.form:
// #         return jsonify({'message': 'Email and password are required.'}), 400
// #
// #     email = request.form['email']
// #     password = request.form['password']
// #
// #     if check_credentials(email, password):
// #         return jsonify({'message': 'Login successful.', 'authenticated': True}), 200
// #     else:
// #         return jsonify({'message': 'Invalid email or password.', 'authenticated': False}), 401
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// # # Set the upload folder path (change it to your desired path)
// # UPLOAD_FOLDER = "C:/Users/HP/PycharmProjects/FYP_Project/path_to_upload_folder"
// # app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
// #
// # ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif'}
// #
// # # Function to check if the file extension is allowed
// # def allowed_file(filename):
// #     return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
// #
// # # Function to connect to the database
// # # ... (your database connection code) ...
// #
// # def resize_image(image_path, max_width, max_height):
// #     # Open the image
// #     img = PILImage.open(image_path)
// #
// #     # Convert the image to RGB mode if it's in RGBA mode
// #     if img.mode == 'RGBA':
// #         img = img.convert('RGB')
// #
// #     # Resize the image while preserving the aspect ratio
// #     img.thumbnail((max_width, max_height))
// #
// #     # Save the resized image as JPEG
// #     img.save(image_path, 'JPEG')
// #
// # @app.route('/addDocument', methods=['POST'])
// # def addDocument():
// #     try:
// #         data = request.json
// #         teacher_id = data.get("TeacherID")
// #         section_id = data.get("SectionID")
// #         title = data.get("Title")
// #         course = data.get("Course")
// #         images = data.get("Images")  # List of base64-encoded image strings
// #
// #         print("Received data:", teacher_id, section_id, title, course)
// #
// #         if not teacher_id or not section_id or not title or not course:
// #             return jsonify({"error": "Missing required data"}), 400
// #
// #         # Check if TeacherID and SectionID are valid foreign keys
// #         connection = connect_to_database()
// #         cursor = connection.cursor()
// #
// #         cursor.execute("SELECT TeacherID FROM Teacher WHERE TeacherID = ?", (teacher_id,))
// #         if cursor.fetchone() is None:
// #             connection.close()
// #             return jsonify({"error": "Invalid TeacherID"}), 400
// #
// #         cursor.execute("SELECT SectionID FROM Section WHERE SectionID = ?", (section_id,))
// #         if cursor.fetchone() is None:
// #             connection.close()
// #             return jsonify({"error": "Invalid SectionID"}), 400
// #
// #         # Get the current system date
// #         current_date = datetime.datetime.now().date()
// #
// #         # Insert into Document table
// #         cursor.execute("INSERT INTO Document (TeacherID, SectionID, Title, Date, Course) VALUES (?, ?, ?, ?, ?)",
// #                        (teacher_id, section_id, title, current_date, course))
// #         connection.commit()
// #
// #         # Get the DocumentID of the inserted row
// #         cursor.execute("SELECT last_insert_rowid()")
// #         document_id = cursor.fetchone()[0]
// #
// #         # Create a directory for the document's images
// #         document_image_dir = os.path.join(app.config['UPLOAD_FOLDER'], str(document_id))
// #         os.makedirs(document_image_dir, exist_ok=True)
// #
// #         # Save and process uploaded images (base64 to image files)
// #         for sequence, base64_image in enumerate(images, start=1):
// #             image_bytes = base64.b64decode(base64_image)
// #             filename = f"image_{sequence}.jpg"  # You can choose the file format here
// #             image_path = os.path.join(document_image_dir, filename)
// #             with open(image_path, "wb") as image_file:
// #                 image_file.write(image_bytes)
// #
// #             # Resize the image to fit within the page boundaries
// #             max_width = 456.0  # Replace with your desired maximum width
// #             max_height = 636.0  # Replace with your desired maximum height
// #             resize_image(image_path, max_width, max_height)
// #
// #             # Insert image path and sequence into Image table
// #             cursor.execute("INSERT INTO Image (DocumentID, ImagePath, Sequence) VALUES (?, ?, ?)",
// #                            (document_id, image_path, sequence))
// #             cursor.execute("SELECT @@IDENTITY")
// #             document_id = cursor.fetchone()[0]
//
// #             connection.commit()
// #
// #
// #         # Generate PDF document with images
// #         pdf_filename = os.path.join(app.config['UPLOAD_FOLDER'], f"document_{document_id}.pdf")
// #         doc = SimpleDocTemplate(pdf_filename, pagesize=letter)
// #
// #         story = []
// #         image_paths = []
// #
// #         # Retrieve image paths from Image table and build PDF
// #         cursor.execute("SELECT ImagePath FROM Image WHERE DocumentID = ? ORDER BY Sequence", (document_id,))
// #         image_paths = [row[0] for row in cursor.fetchall()]
// #
// #         for image_path in image_paths:
// #             img = PILImage.open(image_path)
// #             img_width, img_height = img.size
// #             aspect_ratio = img_height / float(img_width)
// #             new_width = 400
// #             new_height = int(400 * aspect_ratio)
// #             image = Image(image_path, width=new_width, height=new_height)
// #             story.append(image)
// #
// #         doc.build(story)
// #
// #         # Update the DocumentPath column in the Document table
// #         cursor.execute("UPDATE Document SET DocumentPath = ? WHERE DocumentID = ?",
// #                        (pdf_filename, document_id))
// #         connection.commit()
// #
// #         connection.close()
// #
// #         return jsonify({"message": "Document and PDF created successfully", "pdf_path": document_id})
// #
// #     except Exception as e:
// #         print('Error:', str(e))
// #         return jsonify({"error": str(e)}), 500
//
//
//
// #///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// if __name__ == '__main__':
// app.run(host='0.0.0.0', port=5000)
//
