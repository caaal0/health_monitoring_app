import 'package:cmsc23_project/screens/signup/admin_signup.dart';
import 'package:cmsc23_project/screens/signup/monitor_signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../signup.dart';
import 'dart:core';
// import 'package:email_validator/email_validator.dart';

class MonitorLoginPage extends StatefulWidget {
  const MonitorLoginPage({super.key});
  @override
  _MonitorLoginPageState createState() => _MonitorLoginPageState();
}

class _MonitorLoginPageState extends State<MonitorLoginPage> {
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
          return 'Please enter your E-mail';
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

    // log in button that also has validator and will call authentication
    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
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
              print(_formKey.currentState!.validate());
              if (_formKey.currentState!.validate()) {
                String usertype = await context
                    .read<AuthProvider>()
                    .validateUsertype(emailController.text.trim());
                print(usertype);
                String err = '';
                if (usertype == 'monitor') {
                  err = await context.read<AuthProvider>().signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                } else {
                  err = "wrong usertype";
                  print("wrong user type");
                }
                if (err == 'success') {
                  Navigator.pushNamed(context, '/entrance-monitor_homepage');
                } else {
                  print(err);
                }
              }
            },
            child: Text('LOG IN AS ENTRANCE MONITOR',
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
          foregroundColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 37, 67)),
          shape: MaterialStateProperty.all<StadiumBorder>(
            StadiumBorder(),
          ),
        ),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MonitorSignupPage(),
            ),
          );
        },
        child: const Text('Create new account',
            style:
                TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 37, 67))),
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
            SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    empno,
                    SizedBox(
                      height: 15,
                    ),
                    password,
                    SizedBox(
                      height: 20,
                    ),
                    loginButton,
                    const Text('Do not have an account?'),
                    SizedBox(
                      height: 5,
                    ),
                    signUpButton,
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 79, 0, 0)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 67, 0, 0)),
                          shape: MaterialStateProperty.all<StadiumBorder>(
                            StadiumBorder(),
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
