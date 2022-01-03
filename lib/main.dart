import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/pages/home_page.dart';
import 'package:admin_mini/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final AuthMethods _authMethods = AuthMethods();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFT Admin',
      theme: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(
                primaryVariant: const Color(0XFF111528),
                primary: const Color(0xFFFF8902),
              ),
          fontFamily: GoogleFonts.roboto().fontFamily,
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFFFF8902),
          primaryColorDark: const Color(0XFF111528),
          backgroundColor: const Color(0xFFFFB662)),
      home: _authMethods.currentUser() == null ? const Login() : const Home(),
    );
  }
}
