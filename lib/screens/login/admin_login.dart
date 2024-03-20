import 'package:cmsc23_project/screens/signup/admin_signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// import '../signup.dart';
import '../admin/admin_homepage.dart';
import 'dart:core';
// import 'package:email_validator/email_validator.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // text field controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    // text form field for email with validator if valid email
    final empno = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Enter your email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
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
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (!((passwordController.text).length >= 6)) {
          return "Password should be at least 6 characters.";
        }
        return null;
      },
    );

    void showDialogWrongUserType(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Wrong User Type"),
            content: const Text(
                "You are logging in as the wrong user type. Please try again."),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 37, 67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("CLOSE")),
            ],
          );
        },
      );
    }

    void showDialogWrongInput(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text("Wrong Input"),
            content: const Text(
                "The input you provided is incorrect. Please make sure to follow the specified format or provide valid input."),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 37, 67),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("CLOSE")),
            ],
          );
        },
      );
    }

    // log in button that also has validator and will call authentication
    final loginButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          width: 350,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 0, 37, 67)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<StadiumBorder>(
                const StadiumBorder(),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String usertype = await context
                    .read<AuthProvider>()
                    .validateUsertype(emailController.text.trim());
                print(usertype);
                String err = '';
                if (usertype == 'admin') {
                  err = await context.read<AuthProvider>().signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                } else {
                  err = "wrong usertype";
                  showDialogWrongUserType(context);
                }
                if (err == 'success') {
                  // Navigator.pushNamed(context, '/admin_homepage');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminPage(),
                    ),
                  );
                } else {
                  print(err);
                  showDialogWrongInput(context);
                }
              }
            },
            child: const Text('LOG IN AS ADMIN',
                style: TextStyle(color: Colors.white)),
          ),
        ));

    // sign up button will direct you to sign up page
    final signUpButton = SizedBox(
      width: 350,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 0, 37, 67)),
          shape: MaterialStateProperty.all<StadiumBorder>(
            const StadiumBorder(),
          ),
        ),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminSignupPage(),
            ),
          );
        },
        child: const Text('Create new account',
            style:
                TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 37, 67))),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 221, 255),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "LOGIN",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Please sign in to continue.",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(129, 0, 0, 0)),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    empno,
                    const SizedBox(
                      height: 15,
                    ),
                    password,
                    const SizedBox(
                      height: 20,
                    ),
                    loginButton,
                    const Text('Do not have an account?'),
                    const SizedBox(
                      height: 5,
                    ),
                    signUpButton,
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 79, 0, 0)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 67, 0, 0)),
                          shape: MaterialStateProperty.all<StadiumBorder>(
                            const StadiumBorder(),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text('<   BACK',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
