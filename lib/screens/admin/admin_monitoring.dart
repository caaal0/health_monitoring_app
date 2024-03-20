import 'dart:ffi';

import 'package:cmsc23_project/models/user_model.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:cmsc23_project/screens/user/entryform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonitoringStudents extends StatefulWidget {
  const MonitoringStudents({super.key});

  @override
  _MonitoringStudents createState() => _MonitoringStudents();
}

class _MonitoringStudents extends State<MonitoringStudents> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
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
        print("user currently logged in: ${snapshot.data!.uid}");
        // String crrntlogged = snapshot.data!.uid;

        Stream<QuerySnapshot> studentStream =
            context.read<EntryListProvider>().getAllUnderMonitoring();

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
                  user.name,
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remove from monitoring'),
                            content: Text(
                                'Are you sure you want to remove this student from monitoring?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context
                                      .read<EntryListProvider>()
                                      .removeFromUnderMonitoring(
                                          user.id); // Close the dialog
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
                    child: Text('Remove from Monitoring'),
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
        title: Text('Under Monitoring'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 0, 37, 67),
        automaticallyImplyLeading: false,
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       print('pressed logout');
        //       context.read<AuthProvider>().signOut();
        //       Navigator.pop(context);
        //     },
        //     child: Text('Logout'),
        //     style: TextButton.styleFrom(
        //       primary: Colors.white,
        //       textStyle: TextStyle(fontSize: 16),
        //     ),
        //   ),
        // ],
        // title: Text("Admin Dashboard"),
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EntryForm()));
        },
      ),
    );
  }
}
