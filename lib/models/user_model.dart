import 'dart:convert';

class UserRecord {
  // base user properties
  String id;
  String name;
  String email;
  bool isUnderMonitoring;
  bool isQuarantined;
  String userType;

  // SPECIFIC user data
  String? username;
  String? college;
  String? course;
  String? studno;

  //SPECIFC admin/entrance_monitor data
  String? empno;
  String? position;
  String? unit;

  // constructor
  UserRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.isUnderMonitoring,
    required this.isQuarantined,
    required this.userType,
    this.username,
    this.college,
    this.course,
    this.studno,
    this.empno,
    this.position,
    this.unit,
  });

  // creates new instance of user record using data stored in json
  factory UserRecord.fromJson(Map<String, dynamic> json) {
    return UserRecord(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isUnderMonitoring: json['isUnderMonitoring'],
      isQuarantined: json['isQuarantined'],
      userType: json['userType'],
      username: json['username'],
      college: json['college'],
      course: json['course'],
      studno: json['studno'],
      empno: json['empno'],
      position: json['position'],
      unit: json['unit'],
    );
  }

  static List<UserRecord> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserRecord>((dynamic d) => UserRecord.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(UserRecord user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'isUnderMonitoring': user.isUnderMonitoring,
      'isQuarantined': user.isQuarantined,
      'userType': user.userType,
      'username': user.username,
      'college': user.college,
      'course': user.course,
      'studno': user.studno,
      'empno': user.empno,
      'position': user.position,
      'unit': user.unit,
    };
  }
}
