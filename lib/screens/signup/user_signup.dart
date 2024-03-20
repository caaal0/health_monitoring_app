import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});
  @override
  _UserSignupPageState createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // text field controllers
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController collegeController = TextEditingController();
    TextEditingController studnoController = TextEditingController();
    TextEditingController courseController = TextEditingController();

    List<String> allColleges = [
      'College',
      'CAS',
      'CEAT',
      'CHE',
      'CEAT',
      'CAFS',
      'CVM',
      'CFNR',
      'CDC'
    ];

    String currentCollege = allColleges.first;

    Map<String, List> allCourses = {
      'College of Arts and Sciences': [
        'BS Statistics',
        'BS Sociology',
        'BA Philosophy',
        'BS Mathematics and Science Teaching',
        'BS Mathematics',
        'BS Computer Science',
        'BA Communication Arts',
        'BS Chemistry',
        'BS Biology',
        'BS Applied Physics',
        'BS Applied Mathematics'
      ],
      'College of Agriculture and Food Science': [
        'BS Agricultural Chemistry',
        'BS Food Science and Technology',
        'BS Agricultural Biotechnology',
        'BS Agriculture'
      ],
      'College of Development Communication': ['BS Development Communication'],
      'College of Economics and Management': [
        'BS Agricultural and Applied Economics',
        'BS Economics',
        'BS Agribusiness Management and Entrepreneurship'
      ],
      'College of Engineering and Agro-industrial Technology': [
        'BS Materials Engineering',
        'BS Mechanical Engineering',
        'BS Industrial Engineering',
        'BS Electrical Engineering',
        'BS Civil Engineering',
        'BS Chemical Engineering',
        'BS Agricultural and Biosystems Engineering'
      ],
      'College of Forestry and Natural Resources': ['BS Forestry'],
      'College of Human Ecology': ['BS Nutrition', 'BS Human Ecology'],
      'College of Veterinary Medicine': ['Doctor of Veterinary Medicine']
    };

    List<String> retrieveList(String collegeOption) {
      switch (collegeOption) {
        case "CAS":
          return [
            'Course',
            'BS Statistics',
            'BS Sociology',
            'BA Philosophy',
            'BS Mathematics and Science Teaching',
            'BS Mathematics',
            'BS Computer Science',
            'BA Communication Arts',
            'BS Chemistry',
            'BS Biology',
            'BS Applied Physics',
            'BS Applied Mathematics'
          ];
        case "CAFS":
          return [
            'Course',
            'BS Agricultural Chemistry',
            'BS Food Science and Technology',
            'BS Agricultural Biotechnology',
            'BS Agriculture'
          ];
        case "CDC":
          return ['Course', 'BS Development Communication'];
        case "CEM":
          return [
            'Course',
            'BS Agricultural and Applied Economics',
            'BS Economics',
            'BS Agribusiness Management and Entrepreneurship'
          ];
        case "CEAT":
          return [
            'Course',
            'BS Materials Engineering',
            'BS Mechanical Engineering',
            'BS Industrial Engineering',
            'BS Electrical Engineering',
            'BS Civil Engineering',
            'BS Chemical Engineering',
            'BS Agricultural and Biosystems Engineering'
          ];
        case "CFNR":
          return ['Course', 'BS Forestry'];
        case "CHE":
          return ['Course', 'BS Nutrition', 'BS Human Ecology'];
        case "CVM":
          return ['Course', 'Doctor of Veterinary Medicine'];
        default:
          return ['Course'];
      }
    }

    String currentCourse = retrieveList(currentCollege).first;

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
    final username = TextFormField(
      controller: usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Username',
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

    final college = TextFormField(
      controller: collegeController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'College',
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
          return 'Please enter your college';
        }
        return null;
      },
    );

    final studno = TextFormField(
      controller: studnoController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Student Number',
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
          return 'Please enter your student number';
        }
        return null;
      },
    );

    final course = TextFormField(
      controller: courseController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Course',
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
          return 'Please enter your course';
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
                  //make a userrecord model that will be of type student and pass it to signup
                  UserRecord user = UserRecord(
                    id: '',
                    name: nameController.text,
                    username: usernameController.text,
                    email: emailController.text,
                    course: courseController.text,
                    college: collegeController.text,
                    studno: studnoController.text,
                    userType: 'student',
                    isUnderMonitoring: false,
                    isQuarantined: false,
                  );
                  await context.read<AuthProvider>().signUp(
                      emailController.text, passwordController.text, user);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              }
            },
            child: const Text('SIGN UP AS USER',
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
                    email,
                    SizedBox(
                      height: 15,
                    ),
                    password,
                    SizedBox(
                      height: 15,
                    ),
                    name,
                    SizedBox(
                      height: 15,
                    ),
                    username,
                    SizedBox(
                      height: 15,
                    ),
                    college,
                    SizedBox(
                      height: 15,
                    ),
                    course,
                    SizedBox(
                      height: 15,
                    ),
                    studno,
                    SizedBox(
                      height: 15,
                    ),
                    // SizedBox(
                    //   height: 65,
                    //   width: 320,
                    //   child: // Dropdown
                    //       DropdownButtonFormField<String>(
                    //     decoration: InputDecoration(
                    //       filled: true,
                    //       fillColor: Color.fromARGB(255, 255, 255, 255),
                    //     ),
                    //     value: currentCollege,
                    //     dropdownColor: Color.fromARGB(255, 231, 218, 255),
                    //     onChanged: (value) {
                    //       // This is called when the user selects an item.
                    //       // saves the current selected superpower to formValues
                    //       setState(() {
                    //         currentCollege = value.toString();
                    //         // formValues["superpower"] = value.toString();
                    //       });
                    //     },
                    //     // gets the items from the dropdownoptions map
                    //     items: allColleges.map<DropdownMenuItem<String>>(
                    //       (String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(
                    //             value,
                    //             style: const TextStyle(
                    //               color: Color.fromARGB(255, 97, 97, 97),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ).toList(),
                    //     // saves it to formValues
                    //     // onSaved: (newValue) {
                    //     //   setState(() {
                    //     //     formValues["superpower"] = newValue.toString();
                    //     //   });

                    //     //   //print("Dropdown onSaved method triggered");
                    //     // },
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    // SizedBox(
                    //   height: 65,
                    //   width: 320,
                    //   child: // Dropdown
                    //       DropdownButtonFormField<String>(
                    //     decoration: InputDecoration(
                    //       filled: true,
                    //       fillColor: Color.fromARGB(255, 255, 255, 255),
                    //     ),
                    //     value: currentCourse,
                    //     dropdownColor: Color.fromARGB(255, 231, 218, 255),
                    //     onChanged: (value) {
                    //       // This is called when the user selects an item.
                    //       // saves the current selected superpower to formValues
                    //       setState(() {
                    //         currentCourse = value.toString();
                    //         // formValues["superpower"] = value.toString();
                    //       });
                    //     },
                    //     // gets the items from the dropdownoptions map
                    //     items: (retrieveList(currentCollege))
                    //         .map<DropdownMenuItem<String>>(
                    //       (String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(
                    //             value,
                    //             style: const TextStyle(
                    //               color: Color.fromARGB(255, 97, 97, 97),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ).toList(),
                    //     // saves it to formValues
                    //     // onSaved: (newValue) {
                    //     //   setState(() {
                    //     //     formValues["superpower"] = newValue.toString();
                    //     //   });

                    //     //   //print("Dropdown onSaved method triggered");
                    //     // },
                    //   ),
                    // ),
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
