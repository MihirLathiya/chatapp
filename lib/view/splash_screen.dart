import 'dart:async';

import 'package:chatapp/common/text.dart';
import 'package:chatapp/constant.dart';
import 'package:chatapp/view/auth_screens/log_in_screen.dart';
import 'package:chatapp/view/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  String? data;

  Future getData() async {
    var storeData = storage.read('email');
    setState(() {
      data = storeData;
    });
  }

  @override
  void initState() {
    getData().whenComplete(
      () => timer = Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => data != null ? HomeScreen() : LogInScreen(),
          ),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade500,
      body: Center(
        child: Ts(
          text: "Let 's Talk",
          size: 30,
          weight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}
