import 'dart:async';

import 'package:chatapp/common/text.dart';
import 'package:chatapp/constant.dart';
import 'package:chatapp/view/auth_screens/log_in_screen.dart';
import 'package:chatapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
            builder: (context) =>
                data != null ? const HomeScreen() : const LogInScreen(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/78301-conversation.json',
                height: 200, width: 200),
            Ts(
              text: "Let'_s Tal_k",
              size: 35,
              weight: FontWeight.w900,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
