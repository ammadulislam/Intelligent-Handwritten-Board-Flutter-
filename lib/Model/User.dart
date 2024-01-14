class User {
  final int UserID;
  final String Email;
  final String Password;
  final String Role;

  User({
    required this.UserID,
    required this.Email,
    required this.Password,
    required this.Role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userID = json['UserID'] as int?;
    final email = json['Email'] as String?;
    final password = json['Password'] as String?;
    final role = json['Role'] as String?;


    return User(
      UserID: userID ?? 0,
      Email: email ?? '',
      Password: password ?? '',
      Role: role ?? 'defaultRole', // Use a default role if 'Role' is null
    );
  }


}



  // class RegistrationStudent {
  // final String studentName;
  // final String registrationNo;
  // final String discipline;
  // final int sectionID;
  // final int userID;
  //
  // RegistrationStudent({
  // required this.studentName,
  // required this.registrationNo,
  // required this.discipline,
  // required this.sectionID,
  // required this.userID,
  // });
  //
  // // Create a factory constructor to parse JSON
  // factory RegistrationStudent.fromJson(Map<String, dynamic> json) {
  // return RegistrationStudent(
  // studentName: json['StudentName'] as String,
  // registrationNo: json['RegistrationNo'] as String,
  // discipline: json['Discipline'] as String,
  // sectionID: json['SectionID'] as int,
  // userID: json['UserID'] as int,
  // );
  // }
  //
  // // Convert the object to a JSON representation
  // Map<String, dynamic> toJson() {
  // return {
  // 'StudentName': studentName,
  // 'RegistrationNo': registrationNo,
  // 'Discipline': discipline,
  // 'SectionID': sectionID,
  // 'UserID': userID,
  // };
  //}}


class Teacher {
  final String TeacherName;
  final String Designation;
  final String PhoneNo;
  final String Experience;
  final int UserID;

  Teacher({
    required this.TeacherName,
    required this.Designation,
    required this.PhoneNo,
    required this.Experience,
    required this.UserID,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      TeacherName: json['Name'] ?? '',
      Designation: json['Designation'] ?? '',
      PhoneNo: json['Phone'] ?? '',
      Experience: json['Experience'] ?? '',
      UserID: json['UserID'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TeacherName': TeacherName,
      'Designation': Designation,
      'PhoneNo': PhoneNo,
      'Experience': Experience,
      'UserID': UserID,
    };
  }
}


