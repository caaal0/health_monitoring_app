import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/entry_model.dart';
// import '../../api/firebase_entry_api.dart';
// import '../../api/firebase_auth_api.dart';
import '../../providers/auth_provider.dart';
import '../../providers/entry_provider.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EditForm> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();

  static final List<String> choices = ["Yes", "No"];

  List<String> symptoms = [
    'Fever',
    'Feeling feverish',
    'Muscle or joint pains',
    'Cough',
    'Colds',
    'Sore throat',
    'Difficulty of breathing',
    'Diarrhea',
    'Loss of taste',
    'Loss of smell'
  ];

  List<bool> isCheckedList = List<bool>.filled(10, false);

  String isInContact = choices[0];

  bool contactCheck = true;

  Widget formHeader() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    setState(() {
      dateController.text = formattedDate;
    });
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      const Text(
        'ENTRY FORM',
        style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 37, 67)),
      ),
      Text(
        'Date today: $formattedDate',
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 37, 67)),
      ),
      const SizedBox(
        height: 20,
      )
    ]);
  }

  Widget symptomsCheckbox() {
    return Column(
      children: [
        const Divider(
          thickness: 5,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Do you have any pre-exisiting illness? Check all that applies.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // TextField(
        //     controller: dateController, //editing controller of this TextField
        //     decoration: const InputDecoration(
        //         icon: Icon(Icons.calendar_today), //icon of text field
        //         labelText: "Enter Date"),
        //     readOnly: true,
        //     onTap: () async {
        //       DateTime? pickedDate = await showDatePicker(
        //           context: context,
        //           initialDate: DateTime.now(), //get today's date
        //           firstDate: DateTime.now(),
        //           lastDate: DateTime(2101));

        //       if (pickedDate != null) {
        //         String formattedDate =
        //             DateFormat('yyyy-MM-dd').format(pickedDate);

        //         setState(() {
        //           dateController.text = formattedDate;
        //         });
        //       } else {}
        //     }),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: symptoms.length,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 40,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                activeColor: const Color.fromARGB(255, 0, 37, 67),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  symptoms[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: isCheckedList[index],
                // saves currently selected radio button
                onChanged: (value) {
                  setState(() {
                    //print(value.toString());
                    // isInContact = value.toString();
                    isCheckedList[index] = !isCheckedList[index];
                  });
                },
              );
            })
      ],
    );
  }

  Widget covidContact() {
    return Column(
      children: [
        const Divider(
          thickness: 5,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('Have you come in contact with a confirmed COVID-19 case?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: choices.length,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 40,
            itemBuilder: (BuildContext context, int index) {
              // all mottos and their radio buttons
              return RadioListTile(
                title: Text(
                  choices[index],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 66, 43, 110),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: choices[index],
                groupValue: isInContact,
                // saves currently selected radio button
                onChanged: (value) {
                  setState(() {
                    contactCheck = !contactCheck;
                    isInContact = value.toString();
                  });
                },
              );
            }),
      ],
    );
  }

  Widget submitAndResetButtons(
      BuildContext context, Stream<User?> userStream, String newForm) {
    return StreamBuilder(
        stream: userStream,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          print(snapshot.connectionState);
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            String? userId = user?.uid;
            return Column(
              children: [
                const Divider(
                  thickness: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50), // Adjust the width here
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 67, 27)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 67, 27)),
                    shape: MaterialStateProperty.all<StadiumBorder>(
                      const StadiumBorder(),
                    ),
                  ),
                  onPressed: () async {
                    Entry entry = Entry(
                        UID: userId!,
                        date: dateController.text,
                        symptoms: isCheckedList,
                        hasContact: contactCheck,
                        status: 'clone',
                        replacementId: newForm);
                    context.read<EntryListProvider>().addEntry(entry);
                    if (contactCheck) {
                      context.read<EntryListProvider>().putUnderMonitoring(
                          userId); // Retrieve the user record and update the isUnderMonitoring field
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('EDIT ENTRY',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(
                            double.infinity, 50), // Adjust the width here
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 67, 0, 0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 67, 0, 0)),
                      shape: MaterialStateProperty.all<StadiumBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        for (var i = 0; i < isCheckedList.length; i++) {
                          isCheckedList[i] = false;
                        }
                        isInContact = choices[0];
                      });
                    },
                    child: const Text('RESET',
                        style: TextStyle(color: Colors.white))),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    String? replacement = context.read<EntryListProvider>().replacement;
    context.read<AuthProvider>().fetchAuthentication();
    Stream<User?> userStream = context.watch<AuthProvider>().uStream;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 37, 67),
        ),
        //TODO make a form that accepts entries
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            formHeader(),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  symptomsCheckbox(),
                  const SizedBox(
                    height: 15,
                  ),
                  covidContact(),
                  submitAndResetButtons(context, userStream, replacement!),
                ],
              ),
            ),
          ],
        ));
  }
}
