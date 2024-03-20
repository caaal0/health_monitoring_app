import 'dart:ffi';

import 'package:cmsc23_project/models/user_model.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuarantinedStudents extends StatefulWidget {
  const QuarantinedStudents({super.key});

  @override
  _QuarantinedStudents createState() => _QuarantinedStudents();
}

class _QuarantinedStudents extends State<QuarantinedStudents> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    Stream<QuerySnapshot> studentStream =
        context.read<EntryListProvider>().getAllQuarantinedStudents();
    // Stream<QuerySnapshot> entriesStream =
    //     context.watch<EntryListProvider>()._myEntriesStream;
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          print("snapshot has no data");
          return const AdminLoginPage();
        }
        return displayScaffold(context, studentStream);
      },
    );
  }

  Widget studentBuilder(Stream<QuerySnapshot> studentStream) {
    return StreamBuilder(
        stream: studentStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Entries Found"),
            );
          }
          int numberOfStudents = snapshot.data!.docs.length;
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              UserRecord user = UserRecord.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              return ListTile(
                title: Text(
                  'Student number: ${user.studno} - ${user.name}',
                ),
                leading: Text(
                  "${user.studno} - ${user.name}",
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remove from quarantine'),
                            content: Text(
                                'Are you sure you want to remove this student from quarantine?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // context
                                  //     .read<EntryListProvider>()
                                  //     .removeFromQuarantine(
                                  //         user.id); // Close the dialog
                                  // Perform the promotion logic here
                                },
                                child: Text('proceed'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Remove from quarantine'),
                  ),
                ]),
              );
            },
          );
        });

    // return Center();
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> studentStream) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quarantined students"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        automaticallyImplyLeading: false,
        actions: [
          // Display the student count in the app bar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StreamBuilder(
              stream: studentStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  int numberOfStudents = snapshot.data!.docs.length;
                  return Text(
                    '$numberOfStudents Students',
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 37, 67), // First color
              Color.fromARGB(255, 128, 150, 209), // Second color
            ],
          ),
        ),
        child: studentBuilder(studentStream),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/entryform');
        },
      ),
    );
  }
}
