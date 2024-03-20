import 'package:cmsc23_project/providers/entry_provider.dart';
import 'package:cmsc23_project/screens/admin/admin_quarantined.dart';
import 'package:cmsc23_project/screens/admin/admin_requests.dart';
import 'package:cmsc23_project/screens/admin/admin_students.dart';
import 'package:cmsc23_project/screens/entrance_monitor/QR_scanner.dart';
import 'package:cmsc23_project/screens/login/admin_login.dart';
import 'package:cmsc23_project/screens/signup/admin_signup.dart';
import 'package:cmsc23_project/screens/signup/user_signup.dart';
import 'package:cmsc23_project/screens/user/user_homepage.dart';
import 'package:cmsc23_project/screens/login/user_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import '../providers/entry_provider.dart';
import 'screens/admin/admin_homepage.dart';
import 'screens/admin/admin_homepage.dart';
import 'screens/entrance_monitor/entrance_monitor.dart';
import 'screens/user/entryform.dart';
import '../screens/login.dart';
import '../screens/main_menu.dart';
import 'screens/user/user_details.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => EntryListProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health-monitoring App',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const MainMenu(),
        // '/': (context) => const AdminPage(),
        // '/': (context) => const HomePage(),
        // '/': (context) => const EntranceMonitor(),
        // '/login': (context) => const LoginPage(),
        '/user_login': (context) => const UserLoginPage(),
        '/admin_login': (context) => const AdminLoginPage(),
        '/user_signup': (context) => const UserSignupPage(),
        '/admin_signup': (context) => const AdminSignupPage(),
        // '/todo': (context) => const LoginPage(),
        '/quarantined_students': (context) => const QuarantinedStudents(),
        '/user_details': (context) => const UserDetailsPage(),
        '/homepage': (context) => const HomePage(),
        '/entryform': (context) => const EntryForm(),
        '/admin_homepage': (context) => const AdminPage(),
        '/entrance-monitor_homepage': (context) => const EntranceMonitor(),
        '/QR_scanner_page': (context) => const QRViewExample(),
        '/monitor_requests': (context) => const AdminRequests(),
        '/monitor_students': (context) => const ViewStudents(),
        '/monitor_quarantined': (context) => const QuarantinedStudents()
      },
    );
  }
}
