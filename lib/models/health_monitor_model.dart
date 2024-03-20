import 'dart:convert';

class Health_Monitor_Record {
  // Admin properties
  String? id;
  String name;
  String empno;
  String position;
  String unit;
  String email;

  // constructor
  Health_Monitor_Record(
      {required this.id,
      required this.name,
      required this.empno,
      required this.position,
      required this.unit,
      required this.email});

  // creates new instance of Health_Monitor record using data stored in json
  factory Health_Monitor_Record.fromJson(Map<String, dynamic> json) {
    return Health_Monitor_Record(
        id: json['id'],
        name: json['name'],
        empno: json['empno'],
        position: json['position'],
        unit: json['unit'],
        email: json['email']);
  }

  static List<Health_Monitor_Record> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Health_Monitor_Record>(
            (dynamic d) => Health_Monitor_Record.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(Health_Monitor_Record Health_Monitor) {
    return {
      'id': Health_Monitor.id,
      'name': Health_Monitor.name,
      'empno': Health_Monitor.empno,
      'position': Health_Monitor.position,
      'unit': Health_Monitor.unit,
      'email': Health_Monitor.email
    };
  }
}
