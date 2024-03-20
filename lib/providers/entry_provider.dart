import 'package:flutter/material.dart';
import '../api/firebase_entry_api.dart';
// import '../api/firebase_todo_api.dart';
import '../models/entry_model.dart';
import '../models/user_model.dart';
import '../models/log_model.dart';
// import '../models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryListProvider with ChangeNotifier {
  late FirebaseEntryAPI firebaseService;
  late Stream<QuerySnapshot> _entriesStream;
  late Stream<QuerySnapshot> _myEntriesStream;
  Future<List<DocumentSnapshot>>? _userEntryStream;
  late bool _quarantined = false;
  int _quarantineCount = 0;

  Entry? _selectedEntry;
  String? _toEdit;

  EntryListProvider() {
    firebaseService = FirebaseEntryAPI();
    fetchEntries();
    updateQuarantineCount();
  }

  // getter
  Stream<QuerySnapshot> get entries => _entriesStream;
  Stream<QuerySnapshot> get myentries => _myEntriesStream;
  Future<List<DocumentSnapshot>>? get userEntries => _userEntryStream;
  Entry get selected => _selectedEntry!;
  String? get replacement => _toEdit;
  bool get quarantineStatus => _quarantined;
  int get quarantineCount => _quarantineCount;

  changeSelectedEntry(Entry entry) {
    _selectedEntry = entry;
  }

  void setToEdit(String? newToEdit) {
    _toEdit = newToEdit;
    notifyListeners();
  }

  void fetchEntries() {
    _entriesStream = firebaseService.getAllEntries();
    notifyListeners();
  }

  void fetchMyEntries(String UID) async {
    _myEntriesStream = await firebaseService.getEntries(UID);
    notifyListeners();
  }

  Stream<QuerySnapshot> getEntries(String UID) {
    Stream<QuerySnapshot> uEntries = firebaseService.getEntries(UID);
    notifyListeners();
    return uEntries;
  }

  void addLog(Log log) async {
    String message = await firebaseService.addLog(log.toJson(log));
    print(message);
    notifyListeners();
  }

  void addEntry(Entry entry) async {
    String message = await firebaseService.addEntry(entry.toJson(entry));
    print(message);
    notifyListeners();
  }

  // void editTodo(int index, String newTitle) {
  //   // _todoList[index].title = newTitle;
  //   print("Edit");
  //   notifyListeners();
  // }

  void deleteEntry() async {
    String message = await firebaseService.deleteEntry(_selectedEntry!.UID);
    print(message);
    notifyListeners();
  }

  void entryPendingDelete(String? id) async {
    String message = await firebaseService.turnToPendingDelete(id);
    print(message);
    notifyListeners();
  }

  void entryPendingEdit(String? id) async {
    String message = await firebaseService.turnToPendingEdit(id);
    print(message);
    notifyListeners();
  }

  void adminDelete(String? id) async {
    String message = await firebaseService.deletePendingEntries(id);
    print(message);
    notifyListeners();
  }

  void adminTurnToPendingDelete(String? id) async {
    String message = await firebaseService.turnToPendingDelete(id);
    print(message);
    notifyListeners();
  }

  void adminReplaceEntry(String? id1, String? id2) async {
    String message = await firebaseService.replacePendingEntries(id1!, id2!);
    print(message);
    notifyListeners();
  }

  void turnToAdmin(String? id) async {
    String message = await firebaseService.turnToAdmin(id!);
    print(message);
    notifyListeners();
  }

  void turnToStudent(String? id) async {
    String message = await firebaseService.turnToStudent(id!);
    print(message);
    notifyListeners();
  }

  void turnToMonitor(String? id) async {
    String message = await firebaseService.turnToEntranceMonitor(id!);
    print(message);
    notifyListeners();
  }

  void putUnderMonitoring(String? id) async {
    String message = await firebaseService.addToMonitoring(id!);
    print(message);
    notifyListeners();
  }

  void addToQuarantine(String? id) async {
    String message = await firebaseService.addToQuarantine(id!);
    print(message);
    notifyListeners();
  }

  void removeFromQuarantine(String? id) async {
    String message = await firebaseService.removeFromQuarantine(id!);
    print(message);
    notifyListeners();
  }

  void removeFromUnderMonitoring(String? id) async {
    String message = await firebaseService.removeFromUnderMonitoring(id!);
    print(message);
    notifyListeners();
  }

  Future<int> getQuarantineCount() async {
    int count = await firebaseService.getQuarantineCount();
    notifyListeners();
    return count;
  }

  Stream<QuerySnapshot> getPendingEditEntries() {
    Stream<QuerySnapshot> pendingEditEntries =
        firebaseService.getPendingEditEntries();
    // notifyListeners();
    return pendingEditEntries;
  }

  Stream<QuerySnapshot> getPendingDeleteEntries() {
    Stream<QuerySnapshot> pendingDeleteEntries =
        firebaseService.getPendingDeleteEntries();
    // notifyListeners();
    return pendingDeleteEntries;
  }

  Stream<QuerySnapshot> getAllPendingEntries() {
    Stream<QuerySnapshot> pendingEntries =
        firebaseService.getAllPendingEntries();
    print("successfully got pending entries");
    // notifyListeners();
    return pendingEntries;
  }

  Stream<QuerySnapshot> getAllStudents() {
    Stream<QuerySnapshot> allStudents = firebaseService.getAllStudents();
    print("successfully got all Students");
    // notifyListeners();
    return allStudents;
  }

  Stream<QuerySnapshot> getAllQuarantinedStudents() {
    Stream<QuerySnapshot> quarantinedStudents =
        firebaseService.getQuarantinedStudents();
    print("successfully got all Quarantined Students");
    // notifyListeners();
    return quarantinedStudents;
  }

  Stream<QuerySnapshot> getAllUnderMonitoring() {
    Stream<QuerySnapshot> UnderMonitoringStudents =
        firebaseService.getUnderMonitoringStudents();
    print("successfully got all Under Mornitoring students");
    // notifyListeners();
    return UnderMonitoringStudents;
  }

  Future<bool> isQuarantined(String? id) async {
    bool isQuarantined = await firebaseService.isQuarantined(id!);
    notifyListeners();
    return isQuarantined;
  }

  Future<bool> isUnderMonitoring(String? id) async {
    bool isUnderMonitoring = await firebaseService.isUnderMonitoring(id!);
    notifyListeners();
    return isUnderMonitoring;
  }

  Future<void> updateQuarantineCount() async {
    // Fetch and set the quarantine count
    int count = await getQuarantineCount();
    _quarantineCount = count;

    notifyListeners();
  }
}
