import 'package:cmsc23_project/screens/user/entryform.dart';
import 'package:cmsc23_project/screens/user/editform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/user_model.dart';
import 'dart:convert';
import '../../models/log_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Entry> entries = [];

  Widget entryList(BuildContext context, int index, String UID) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    if (index == 0) {
      return displayUserEntries(userStream);
      // return Center(
      //   child: Text("No entries yet"),
      // );
    } else if (index == 1) {
      return profileBuilder(UID);
    } else {
      return displayUserEntries(userStream);
    }
  }

  Widget displayUserEntries(Stream<User?> userStream) {
    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Text("snapshot has no data");
        }

        String UID = snapshot.data!.uid;
        Stream<QuerySnapshot> entriesStream =
            context.read<EntryListProvider>().getEntries(UID);
        // Delay the execution of code until after the build method has complete
        // If user is logged in, display the scaffold containing the streambuilder for the todos
        return entriesBuilder(entriesStream, UID);
      },
    );
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

  Widget entriesBuilder(Stream<QuerySnapshot> entriesStream, String UID) {
    return StreamBuilder(
      stream: entriesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        }
        // else if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: Text('this is loading'),
        //   );
        // }
        else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No Entries Found",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
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
                                                  fontWeight: FontWeight.bold),
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
                                    content:
                                        Text("Entry is now pending for delete"),
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
      },
    );
  }

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

  Widget profileBuilder(String UID) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('###################$formattedDate');
    Stream<QuerySnapshot> userDocs =
        context.watch<AuthProvider>().getUserDocs(UID);

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
              child: Text(
                "No Entries Found",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
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
                                    'QR CODE GENERATED',
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? uid = context.read<AuthProvider>().getCurrentUser()?.uid;

    return FutureBuilder<bool>(
      future: context.read<EntryListProvider>().isQuarantined(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the future is in progress
          return Scaffold(
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle the error case
          return Scaffold(
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
              child: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          // Future completed successfully
          bool isQuarantined = snapshot.data ?? false;

          return Scaffold(
            // drawer: Drawer(child: Text('Drawer')),
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
              //       print('pessed logout');
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
              title: Text(
                isQuarantined ? "Quarantined" : "Not Quarantined",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // title: Text("User's "),
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
              child: entryList(
                context,
                _selectedIndex,
                uid!,
              ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 0, 37, 67),
              onPressed: () {
                // Navigator.pushNamed(context, '/entryform');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EntryForm()),
                );
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined),
                  label: 'Entries',
                  backgroundColor: Color.fromARGB(255, 0, 37, 67),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                  backgroundColor: Colors.black,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color.fromARGB(255, 255, 255, 255),
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
