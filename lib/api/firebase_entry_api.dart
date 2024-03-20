import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEntryAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> addLog(Map<String, dynamic> log) async {
    try {
      await db.collection('entrance_monitor').add(log);
      return "Successfully added log";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addEntry(Map<String, dynamic> entry) async {
    try {
      final docRef = await db.collection("entries").add(entry);
      await db.collection("entries").doc(docRef.id).update({'id': docRef.id});
      return "Successfully added entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllEntries() {
    return db
        .collection("entries")
        .where("status", whereIn: ["pendingEdit", "clone"]).snapshots();
  }

  Stream<QuerySnapshot> getAllStudents() {
    print('getting students');
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .snapshots();
  }

  Stream<QuerySnapshot> getQuarantinedStudents() {
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .where("isQuarantined", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUnderMonitoringStudents() {
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .where("isUnderMonitoring", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingDeleteEntries() {
    return db
        .collection("entries")
        .where("status", isEqualTo: "pendingDelete")
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingEditEntries() {
    return db
        .collection("entries")
        .where("status", isEqualTo: "pendingEdit")
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPendingEntries() {
    return db
        .collection("entries")
        .where("status", whereIn: ["clone", "pendingDelete"]).snapshots();
  }

  Future<String> deletePendingEntries(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "deleted"});

    return 'successfully deleted pending entry';
  }

  Future<String> addToQuarantine(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isQuarantined": true});
      });
    });
    return 'successfully put student into quarantine';
  }

  Future<String> addToMonitoring(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isUnderMonitoring": true});
      });
    });
    return 'successfully put student into monitoring';
  }

  Future<String> turnToAdmin(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"userType": "admin"});
      });
    });
    return 'successfully turned student to admin';
  }

  Future<String> turnToStudent(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"userType": "student"});
      });
    });
    return 'successfully turned student to admin';
  }

  Future<String> turnToEntranceMonitor(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"userType": "monitor"});
      });
    });
    return 'successfully turned student to monitor';
  }

  Future<String> turnToPendingDelete(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "pendingDelete"});
    return 'successfully put entry to pending delete';
  }

  Future<String> turnToPendingEdit(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "pendingEdit"});
    return 'successfully put entry to pending edit';
  }

  Future<int> getQuarantineCount() async {
    CollectionReference usersCollection = db.collection("users");

    QuerySnapshot snapshot = await usersCollection
        .where("isQuarantined", isEqualTo: true)
        .where("userType", isEqualTo: "student")
        .get();

    int count = snapshot.docs.length;
    print('successfully got quarantine count');
    print("this is the count: $count");
    return count;
  }

  Future<bool> isQuarantined(String id) async {
    CollectionReference usersCollection = db.collection("users");

    QuerySnapshot snapshot = await usersCollection
        .where("id", isEqualTo: id)
        .where("isQuarantined", isEqualTo: true)
        .get();

    bool isQuarantined = snapshot.docs.isNotEmpty;
    return isQuarantined;
  }

  Future<bool> isUnderMonitoring(String id) async {
    CollectionReference usersCollection = db.collection("users");

    QuerySnapshot snapshot = await usersCollection
        .where("id", isEqualTo: id)
        .where("isUnderMonitoring", isEqualTo: true)
        .get();

    bool isQuarantined = snapshot.docs.isNotEmpty;
    return isQuarantined;
  }

  Future<String> removeFromQuarantine(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isQuarantined": false});
      });
    });

    return 'successfully removed student from quarantine';
  }

  Future<String> removeFromUnderMonitoring(String id) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isUnderMonitoring": false});
      });
    });

    return 'successfully removed student from monitoring';
  }

  Future<String> replacePendingEntries(String id1, String id2) async {
    CollectionReference entriesCollection = db.collection("entries");

    DocumentSnapshot snapshot1 = await entriesCollection.doc(id1).get();
    DocumentSnapshot snapshot2 = await entriesCollection.doc(id2).get();
    if (snapshot1.exists && snapshot2.exists) {
      Map<String, dynamic> data2 = snapshot2.data() as Map<String, dynamic>;
      String preserveId = snapshot1.id; // Get the original 'id' field value

      data2['id'] =
          preserveId; // Set the 'id' field in data2 to the original 'id' value
      data2['replacementId'] = null;
      // Remove the 'id' and 'status' fields from data2, so they won't be overwritten
      data2.remove('status');

      await entriesCollection
          .doc(id1)
          .set(data2); // Replace the content of id1 with data2
      await entriesCollection.doc(id2).delete(); // Delete snapshot2
      await entriesCollection.doc(id1).update({'status': 'open'});
      return 'Successfully replaced content of $id1 with $id2 and deleted $id2';
    } else {
      return 'Document with ID $id1 or $id2 does not exist';
    }
  }

  Stream<QuerySnapshot> getEntries(String UID) {
    final refs = db.collection('entries');
    return refs
        .where('UID', isEqualTo: UID)
        .where('status', whereNotIn: ['clone', 'deleted']).snapshots();
  }

  Stream<QuerySnapshot> getClone(String id) {
    return db
        .collection('entries')
        .where('replacementId', isEqualTo: id)
        .snapshots();
  }
  // Stream<QuerySnapshot> getMyEntries(){

  // }

  Future<String> deleteEntry(String? id) async {
    try {
      await db.collection("entries").doc(id).delete();

      return "Successfully deleted entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
