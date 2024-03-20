import 'package:cmsc23_project/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/health_monitor_model.dart';
import '../../providers/auth_provider.dart';

class MonitorSignupPage extends StatefulWidget {
  const MonitorSignupPage({super.key});
  @override
  _MonitorSignupPageState createState() => _MonitorSignupPageState();
}

class _MonitorSignupPageState extends State<MonitorSignupPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // text field controllers
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController empnoController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController homeUnitController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    final name = TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        } else if (value.contains(RegExp(r'[0-9]'))) {
          return 'Name has numbers';
        }
        return null;
      },
    );
    final empno = TextFormField(
      controller: empnoController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Employee Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your employee number';
        } else if (RegExp(r'[A-Za-z]').hasMatch(value)) {
          return 'Contains letters';
        }
        return null;
      },
    );

    final position = TextFormField(
      controller: positionController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Work Position',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your work position';
        }
        return null;
      },
    );

    final homeUnit = TextFormField(
      controller: homeUnitController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Home Unit',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your home unit';
        }
        return null;
      },
    );

    final email = TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        // FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

        // Future<bool> isEmailAlreadyInUse(String email) async {
        //   try {
        //     final result =
        //         await _firebaseAuth.fetchSignInMethodsForEmail(email);
        //     return result.isNotEmpty;
        //   } catch (e) {
        //     // Handle any errors that occur during the process
        //     print('Error checking email usage: $e');
        //     return false;
        //   }
        // }

        // bool emailExists =
        //           await isEmailAlreadyInUse(emailController.text);

        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!(RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value))) {
          return 'Invalid email format';
        }
        return null;
      },
    );
    // text form field for password with validator if at least 6 characters
    final password = TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (!((passwordController.text).length >= 6)) {
          return "Password should be at least 6 characters.";
        }

        return null;
      },
    );

    // sign up button will direct you to sign up page
    final SignupButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          width: 350,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 0, 37, 67)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<StadiumBorder>(
                StadiumBorder(),
              ),
            ),
            onPressed: () async {
              FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

              Future<bool> isEmailAlreadyInUse(String email) async {
                try {
                  final result =
                      await _firebaseAuth.fetchSignInMethodsForEmail(email);
                  return result.isNotEmpty;
                } catch (e) {
                  // Handle any errors that occur during the process
                  print('Error checking email usage: $e');
                  return false;
                }
              }

              bool emailExists =
                  await isEmailAlreadyInUse(emailController.text);
              if (emailExists) {
                print("dito siya pumasok");
                // Prompt the user that the email is already in use
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Email Already in Use'),
                      content: Text(
                          'The email address is already registered. Please use a different email.'),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();

                  UserRecord health_monitor = UserRecord(
                    id: '',
                    name: nameController.text,
                    empno: empnoController.text,
                    position: positionController.text,
                    unit: homeUnitController.text,
                    email: emailController.text,
                    isQuarantined: false,
                    isUnderMonitoring: false,
                    userType: 'monitor',
                  );

                  await context.read<AuthProvider>().signUp(
                      emailController.text,
                      passwordController.text,
                      health_monitor);

                  if (context.mounted) Navigator.pop(context);
                }
              }
            },
            child: const Text('SIGN UP AS ENTRANCE MONITOR',
                style: TextStyle(color: Colors.white)),
          ),
        ));

    // back button
    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(255, 79, 0, 0)),
          foregroundColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(255, 67, 0, 0)),
          shape: MaterialStateProperty.all<StadiumBorder>(
            StadiumBorder(),
          ),
        ),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('<   BACK',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 221, 255),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "SIGN UP",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Please sign in to continue.",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(129, 0, 0, 0)),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    name,
                    SizedBox(
                      height: 15,
                    ),
                    empno,
                    SizedBox(
                      height: 15,
                    ),
                    position,
                    SizedBox(
                      height: 15,
                    ),
                    homeUnit,
                    SizedBox(
                      height: 15,
                    ),
                    email,
                    SizedBox(
                      height: 15,
                    ),
                    password,
                    SizedBox(
                      height: 15,
                    ),
                    SignupButton,
                    backButton
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
