import 'package:cmsc23_project/screens/admin/admin_quarantined.dart';
import 'package:cmsc23_project/screens/admin/admin_monitoring.dart';
import 'package:cmsc23_project/screens/admin/admin_requests.dart';
import 'package:cmsc23_project/screens/admin/admin_students.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/entry_model.dart';
import '../../models/log_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cmsc23_project/screens/user/entryform.dart';
import 'dart:convert';
import 'package:cmsc23_project/screens/user/entryform.dart';
import 'package:cmsc23_project/screens/user/editform.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Entry> entries = [];
  int _selectedIndex = 0;

  //builds the four buttons that will be used to view students
  Widget students_buttons() {
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminRequests()));
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_notifications,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All Requests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewStudents()));
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.groups_2_sharp,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "All Students",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuarantinedStudents()));
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.coronavirus,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Quarantined",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MonitoringStudents()));
            },
            child: SizedBox(
              width: 160,
              height: 200,
              child: Card(
                shadowColor: Color.fromRGBO(214, 214, 214, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 50,
                          color: Color.fromARGB(255, 0, 37, 67),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Monitoring",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 37, 67)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //builds the profile of the admin
  Future<bool> checkConditions(String UID) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    bool today = false;
    bool isUnderQuarantine =
        await context.read<EntryListProvider>().isQuarantined(UID);
    bool isUnderMonitoring =
        await context.read<EntryListProvider>().isUnderMonitoring(UID);
    for (Entry entry in entries) {
      print(entry.date);
      if (entry.date == formattedDate) {
        today = true;
      }
    }
    if (today == true &&
        isUnderQuarantine == false &&
        isUnderMonitoring == false) {
      print('@@@@@@@@@@@@$today, $isUnderQuarantine, $isUnderMonitoring');
      return true;
    } else {
      print('!!!!!!!!!!!!!!!!$today, $isUnderQuarantine, $isUnderMonitoring');
      return false;
    }
  }

  Widget profileBuilder(Stream<QuerySnapshot<Object?>> userDocs, UID) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('###################$formattedDate');
    return StreamBuilder(
        stream: userDocs,
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

          UserRecord user = UserRecord.fromJson(
              snapshot.data?.docs[0].data() as Map<String, dynamic>);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 0, 13, 47),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color.fromARGB(255, 252, 253, 255),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${user.name}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() async {
                        bool able = await checkConditions(UID);
                        if (able) {
                          Log log = Log(
                              date: formattedDate,
                              name: user.name,
                              location: 'Physci',
                              studno: user.studno,
                              empno: user.empno);
                          Map<String, dynamic> message = log.toJson(log);
                          String jsonMessage = jsonEncode(message);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'QR CODE GENERATED.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Container(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: QrImage(
                                      // TODO change the data to an instance of entry, but for that to work
                                      // need to implement getting of entries from stream first
                                      data: jsonMessage,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'QR CODE CANT BE GENERATED.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Container(
                                  width: 200,
                                  height: 200,
                                  child: Text(
                                    'Either: You dont\'t have an entry for today\nYou are under quarantine\n You are under monitoring',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        // _isVisible = !_isVisible;
                      });
                    },
                    child: Text("VIEW BUILDING PASS"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 37, 67),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<StadiumBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 0, 0),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<StadiumBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthProvider>().signOut();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.exit_to_app), Text("LOGOUT")],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
          // return Center();
        });
  }

  Widget hasContactWidget(entry) {
    for (int i = 0; i < entry.symptoms.length; i++) {
      if (entry.symptoms[i] == true) {
        // print("hey");
        return Row(
          children: [
            Center(
              child: Text(
                "Has Symptoms: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text("TRUE"),
            )
          ],
        );
        break;
      } else {
        // print("hello");
        return Row(
          children: [
            Center(
              child: Text(
                "has Symptoms: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text("FALSE"),
            )
          ],
        );
      }
    }
    return Text("back to u hey");
    return Row(
      children: [
        Center(
          child: Text(
            "has Symptoms: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text("FALSE"),
        )
      ],
    );
  }

  //builds entries from stream
  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream, String UID) {
    print("at entries builder");
    return StreamBuilder(
        stream: entriesStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('this is causing an error'));
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
                  snapshot.data?.docs[index].data() as Map<String, dynamic>,
                );
                entries.add(entry);

                return SizedBox(
                  height: 80,
                  child: Card(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: ListTile(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(entry.hasContact
                                                  .toString()
                                                  .toUpperCase()),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Status: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(entry.status.toString()),
                                            )
                                          ],
                                        ),
                                        hasContactWidget(entry),
                                      ],
                                    ),
                                  ),
                                  actions: [
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
                                        child: Text("CLOSE")),
                                  ],
                                );
                              });
                        },
                        title: Text(
                          entry.date + " ENTRY",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 0, 37, 67),
                          child: Text((index + 1).toString()),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 0, 37, 67),
                              ),
                              onPressed: () {
                                String? docrefID = entry.id;
                                String? status = entry.status;
                                if (status == "open") {
                                  context
                                      .read<EntryListProvider>()
                                      .entryPendingEdit(docrefID);
                                  context
                                      .read<EntryListProvider>()
                                      .setToEdit(docrefID);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Entry is now pending for edit"),
                                    ),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditForm()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Entry is already pending"),
                                    ),
                                  );
                                }

                                // Perform edit operation for the entry
                                // You can navigate to an edit screen or show a dialog
                                // to allow the user to modify the entry.
                                // Example: navigate to EditEntryScreen(entry);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 0, 37, 67),
                              ),
                              onPressed: () {
                                String? docrefID = entry.id;
                                String? status = entry.status;
                                if (status == "open") {
                                  context
                                      .read<EntryListProvider>()
                                      .entryPendingDelete(docrefID);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Entry is now pending for delete"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Entry is already pending"),
                                    ),
                                  );
                                }

                                // Perform edit operation for the entry
                                // You can navigate to an edit screen or show a dialog
                                // to allow the user to modify the entry.
                                // Example: navigate to EditEntryScreen(entry);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
// return Center();
        });
  }

  //this function returns a different widget depending on the index of the
  //bottomnav bar
  body(int index, Stream<QuerySnapshot> entriesStream,
      Stream<QuerySnapshot<Object?>> userDocs, String UID) {
    if (index == 0) {
      return students_buttons();
    } else if (index == 1) {
      return entriesBuilder(entriesStream, UID);
    } else if (index == 2) {
      return profileBuilder(userDocs, UID);
    }
  }

  _itemOnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<QuerySnapshot> getEntriesStream(String UID) {
    Stream<QuerySnapshot> entriesStream =
        context.watch<EntryListProvider>().getEntries(UID);
    return entriesStream;
  }

  @override
  Widget build(BuildContext context) {
    //keep watching userStream
    context.watch<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    print('you are at homepage');
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
          // if snapshot has no data, keep returning the login page
          //TODO have UI prompt like alertdialog or new screent instead
          print("snapshot has no data");
          return const AdminLoginPage();
        }
        print("user currently logged in: ${snapshot.data!.uid}");
        //get the UID of currently logged in user and use it to get stream of their entries
        String UID = snapshot.data!.uid;
        Stream<QuerySnapshot> entriesStream = getEntriesStream(UID);
        Stream<QuerySnapshot> userDocs =
            context.read<AuthProvider>().getUserDocs(UID);
        return displayScaffold(context, entriesStream, userDocs, UID);
      },
    );
  }

  //if a user succesfully logs in, return this scaffold
  Scaffold displayScaffold(
      BuildContext context,
      Stream<QuerySnapshot<Object?>> entriesStream,
      Stream<QuerySnapshot<Object?>> userDocs,
      String UID) {
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
        child: body(_selectedIndex, entriesStream, userDocs, UID),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Students",
            backgroundColor: Color.fromARGB(255, 0, 13, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Entries",
            backgroundColor: Color.fromARGB(255, 0, 42, 57),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color.fromARGB(255, 0, 43, 33),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _itemOnTapped,
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
