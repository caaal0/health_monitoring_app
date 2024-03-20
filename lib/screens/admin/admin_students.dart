import 'package:cmsc23_project/models/user_model.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/entry_model.dart';
import '../../providers/entry_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cmsc23_project/screens/user/entryform.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({super.key});

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  Timer? _debounce;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    print(userStream);

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
            context.read<EntryListProvider>().getAllStudents();

        return displayScaffold(context, studentStream);
      },
    );
  }

  Widget studentBuilder(
      Stream<QuerySnapshot> studentStream, String? searchQuery) {
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

          List<UserRecord>? filteredUsers = snapshot.data?.docs
              .map((doc) =>
                  UserRecord.fromJson(doc.data() as Map<String, dynamic>))
              .where((user) {
            final lowerCaseQuery = searchQuery!.toLowerCase();
            final lowerCaseName = user.name.toLowerCase();
            final lowerCaseCourse = user.course!.toLowerCase();

            return lowerCaseName.contains(lowerCaseQuery) ||
                lowerCaseCourse.contains(lowerCaseQuery);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: filteredUsers!.length,
              itemBuilder: (context, index) {
                UserRecord user = filteredUsers![index];
                return Container(
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
                                    '${user.name}\'s DETAILS',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  content: Container(
                                    width: 200,
                                    height: 400,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Name: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(user.name),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Student Number: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.studno.toString()),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Email: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(user.email),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "College: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.college.toString()),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Course: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child:
                                                  Text(user.course.toString()),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext innerContext) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title: Center(
                                                      child: Text(
                                                    'PROMOTE TO ADMIN',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to promote this user to admin?'),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  0,
                                                                  67,
                                                                  19),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  innerContext)
                                                              .pop();
                                                          context
                                                              .read<
                                                                  EntryListProvider>()
                                                              .turnToAdmin(user
                                                                  .id); // Close the dialog
                                                          // Perform the promotion logic here
                                                        },
                                                        child: Text("PROMOTE")),
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
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PROMOTE TO ADMIN'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 37, 67),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

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
                                                    'PROMOTE TO MONITOR',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to promote this student to monitor?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 67, 19),
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
                                                            .turnToMonitor(user
                                                                .id); // Perform the promotion logic here
                                                      },
                                                      child: Text('PROMOTE'),
                                                    ),
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
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PROMOTE TO MONITOR'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 67, 19),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

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
                                                    'PUT IN QUARANTINE',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                  content: Text(
                                                      'Are you sure you want to put this student into quarantine?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 0, 67, 19),
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
                                                        context
                                                            .read<
                                                                EntryListProvider>()
                                                            .addToQuarantine(
                                                                user.id);
                                                      },
                                                      child: Text('QUARANTINE'),
                                                    ),
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
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('CANCEL'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('PUT IN QUARANTINE'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 67, 0, 0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the border radius
                                            ),
                                            minimumSize: Size(200,
                                                50), // Set the minimum size of the button
                                            padding: EdgeInsets.all(
                                                20), // Set the padding around the button
                                            // You can customize other properties like background color, text style, etc.
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "GO BACK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 37, 67)),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: ListTile(
                          title: Text(
                            user.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Student number: " + user.studno.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 0, 37, 67),
                            child: Text((index + 1).toString()),
                          ),
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = newQuery;
      });
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Scaffold displayScaffold(
      BuildContext context, Stream<QuerySnapshot<Object?>> studentStream) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('Search'),
        actions: _buildActions(),
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
        child: studentBuilder(studentStream, searchQuery),
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
