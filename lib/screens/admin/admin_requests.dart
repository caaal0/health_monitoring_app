import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cmsc23_project/screens/user/entryform.dart';

class AdminRequests extends StatefulWidget {
  const AdminRequests({super.key});

  @override
  _AdminRequestsState createState() => _AdminRequestsState();
}

class _AdminRequestsState extends State<AdminRequests> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    print(userStream);
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
        print("user currently logged in: ${snapshot.data!.uid}");
        // String crrntlogged = snapshot.data!.uid;

        Stream<QuerySnapshot> entriesStream =
            context.read<EntryListProvider>().getAllPendingEntries();

        return displayScaffold(context, entriesStream);
      },
    );
  }

  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream) {
    print("at entries builder");
    return StreamBuilder(
        stream: entriesStream,
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

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Entry entry = Entry.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                return SizedBox(
                  height: 80,
                  child: Card(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title: Center(
                                    child: Text(
                                  'ENTRY DETAILS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                content: Container(
                                  width: 200,
                                  height: 80,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              "Date Submitted: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Center(
                                            child: Text(entry.date),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              "Has Contact: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                                entry.hasContact.toString()),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Center(
                                            child:
                                                Text(entry.status.toString()),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 67, 3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        // context
                                        //     .read<EntryListProvider>()
                                        //     .adminReplaceEntry(
                                        //         entry.replacementId, entry.id);

                                        if (entry.status == 'clone') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                title: Text('Approve Edit'),
                                                content: Text(
                                                    'Are you sure you want to approve this edit?'),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 67, 3),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        context
                                                            .read<
                                                                EntryListProvider>()
                                                            .adminReplaceEntry(
                                                                entry
                                                                    .replacementId,
                                                                entry.id);
                                                      },
                                                      child: Text("APPROVE")),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 37, 67),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("CLOSE")),
                                                  // TextButton(
                                                  //   onPressed: () {
                                                  //     Navigator.of(context)
                                                  //         .pop(); // Close the dialog
                                                  //     context
                                                  //         .read<EntryListProvider>()
                                                  //         .adminReplaceEntry(
                                                  //             entry.replacementId,
                                                  //             entry.id);
                                                  //   },
                                                  //   child: Text('Approve'),
                                                  // ),
                                                  // TextButton(
                                                  //   onPressed: () {
                                                  //     Navigator.of(context)
                                                  //         .pop(); // Close the dialog
                                                  //   },
                                                  //   child: Text('Cancel'),
                                                  // ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                title: Center(
                                                    child: Text(
                                                  'DELETE ENTRY',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                content: Text(
                                                    'Are you sure you want to delete this entry?'),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 67, 0, 0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        context
                                                            .read<
                                                                EntryListProvider>()
                                                            .adminDelete(
                                                                entry.id);
                                                      },
                                                      child: Text("DELETE")),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 37, 67),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("CLOSE")),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text("APPROVE EDIT")),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 37, 67),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("CLOSE"))
                                  // TextButton(
                                  //   child: Text('Close'),
                                  //   onPressed: () {
                                  //     Navigator.of(context).pop();
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(
                            'ENTRY DATE: ${entry.date}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "status: " + entry.status!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 0, 37, 67),
                            child: Text((index + 1).toString()),
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 12, 67, 0),
                            child: GestureDetector(
                              onTap: () {
                                if (entry.status == 'clone') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Text('Approve Edit'),
                                        content: Text(
                                            'Are you sure you want to approve this edit?'),
                                        actions: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 67, 3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                                context
                                                    .read<EntryListProvider>()
                                                    .adminReplaceEntry(
                                                        entry.replacementId,
                                                        entry.id);
                                              },
                                              child: Text("APPROVE")),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 37, 67),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("CLOSE")),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     Navigator.of(context)
                                          //         .pop(); // Close the dialog
                                          //     context
                                          //         .read<EntryListProvider>()
                                          //         .adminReplaceEntry(
                                          //             entry.replacementId,
                                          //             entry.id);
                                          //   },
                                          //   child: Text('Approve'),
                                          // ),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     Navigator.of(context)
                                          //         .pop(); // Close the dialog
                                          //   },
                                          //   child: Text('Cancel'),
                                          // ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        title: Center(
                                            child: Text(
                                          'DELETE ENTRY',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                        content: Text(
                                            'Are you sure you want to delete this entry?'),
                                        actions: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 67, 0, 0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                                context
                                                    .read<EntryListProvider>()
                                                    .adminDelete(entry.id);
                                              },
                                              child: Text("DELETE")),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 0, 37, 67),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("CLOSE")),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.check),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );

          ;

          // return Center();
        });
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> entriesStream) {
    return Scaffold(
      appBar: AppBar(
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
        child: entriesBuilder(entriesStream),
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
