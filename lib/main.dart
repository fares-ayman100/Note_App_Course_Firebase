import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Const/const.dart';
import 'package:notes_app_firebase/Views/Auth/LoginPage.dart';
import 'package:notes_app_firebase/Views/Auth/SignUp.dart';
import 'package:notes_app_firebase/Views/HomePage.dart';
import 'package:notes_app_firebase/Views/category/add.dart';
import 'package:notes_app_firebase/filter.dart';
import 'package:notes_app_firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme:  AppBarTheme(
            backgroundColor: kprimarycolor,
            titleTextStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: Colors.white, size: 30)),
      ),
      debugShowCheckedModeBanner: false,
      home: const FilterPage(),
      // FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified
      //     ? const HomePage()
      //     : const LoginPage(),
      routes: {
        'signUp': (context) => const SignUp(),
        'Login': (context) => const LoginPage(),
        'homePage': (context) => const HomePage(),
        'addPage': (context) => const AddCategory(),
      },
    );
  }
}
