import 'dart:io';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'sendotp.dart';
import 'enterotp.dart';
import 'resetpass.dart';
import 'home.dart';
import 'weeklytest.dart';
import 'StudentAttendance.dart';
import 'staffattd.dart';
import 'homework.dart';
import 'profile.dart';
import 'exam_result.dart';
import 'fee_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() {
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Set the status bar color here
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
     @override
     _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Admin App",
      home: token != '' ? Home() : Login(),
      routes: {
        '/login': (context) => Login(),
        '/setotp': (context) => SetOtp(),
        '/EnterOTP' : (context) => OtpEntryScreen(),
        '/ResetPass' : (context) => ResetPass(),
        '/home' : (context) => Home(),
        '/weektest' : (context) => const WeeklyTest(),
        '/stdAttd' : (context) => const StudentAttd(),
        '/staffAttd' : (context) => const StaffAttd(),
        '/homework' : (context) => const HomeWork(),
        '/profile' : (context) => StudentProfile(),
        '/exam' : (context) => const ExamReport(),
        '/fee' : (context) => const FeeReport(),
      },
    );
  }
}