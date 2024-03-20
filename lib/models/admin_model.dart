import 'dart:convert';

class AdminRecord {
  // Admin properties
  String? id;
  String name;
  String empno;
  String position;
  String unit;
  String email;
  List<String>? entries;

  // constructor
  AdminRecord({
    required this.id,
    required this.name,
    required this.empno,
    required this.position,
    required this.unit,
    required this.email,
    this.entries
  });

  // creates new instance of Admin record using data stored in json
  factory AdminRecord.fromJson(Map<String, dynamic> json) {
    return AdminRecord(
        id: json['id'],
        name: json['name'],
        empno: json['empno'],
        position: json['position'],
        unit: json['unit'],
        email: json['email'],
        entries: json['entries']
        );
  }

  static List<AdminRecord> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AdminRecord>((dynamic d) => AdminRecord.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(AdminRecord Admin) {
    return {
      'id': Admin.id,
      'name': Admin.name,
      'empno': Admin.empno,
      'position': Admin.position,
      'unit': Admin.unit,
      'email': Admin.email,
      'entries': Admin.entries
    };
  }
}
