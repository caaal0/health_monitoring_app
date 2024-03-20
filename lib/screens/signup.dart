import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // text field controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    // text form field for email with validator if valid email
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Email",
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
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text);

        if (!emailValid) {
          return "Please enter a valid email address";
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
              if (_formKey.currentState!.validate()) {
                // UserRecord tempUser = UserRecord(
                //   id: "123",
                //   fname: firstNameController.text,
                //   lname: lastNameController.text,
                //   email: emailController.text,
                //   entries: [],
                // );

                // context.read<AuthProvider>().signUp(
                //     emailController.text, passwordController.text, tempUser);

                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
          ),
        ));

    // back button
    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      ),
    );

    // text field for getting input of first name
    // with validator (makes it required)
    final firstName = TextFormField(
      controller: firstNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'First Name',
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
          return 'Please enter your first name';
        }

        return null;
      },
    );

    // text field for getting input of last name
    // with validator (makes it required)
    final lastName = TextFormField(
      controller: lastNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Last Name',
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
        }
        return null;
      },
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
                    firstName,
                    SizedBox(
                      height: 15,
                    ),
                    lastName,
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
