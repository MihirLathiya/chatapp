import 'package:chatapp/view/auto_fill_otp/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constant.dart';

String? verifyId;
TextEditingController mobile = TextEditingController();

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  Future sendOtp() async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91' + mobile.text,
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        Get.snackbar('Code Sent', '');
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          verifyId = verificationId;
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        Get.snackbar('Failed', '$error', duration: const Duration(seconds: 10));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: mobile,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Enter Mobile No',
                  counter: Offstage(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await sendOtp().then(
                      (value) => Get.to(
                        () => const OtpScreen(),
                      ),
                    );
                  },
                  child: const Text('send OTP'))
            ],
          ),
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otp = TextEditingController();
  Future verifyOtp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verifyId!, smsCode: _otp.text);

    if (phoneAuthCredential.smsCode == null) {
      Get.snackbar('Empty', 'Enter OTP');
    } else {
      final signCode = SmsAutoFill().getAppSignature;
      print(signCode);
      await phoneAuth
          .doc(firebaseAuth.currentUser?.phoneNumber)
          .set({'phoneNum': mobile.text}).whenComplete(
        () => Get.to(
          () => const HomePage(),
        ),
      );
    }
    firebaseAuth.signInWithCredential(phoneAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PinFieldAutoFill(
                controller: _otp,
                codeLength: 6,
                keyboardType: TextInputType.number,
                onCodeSubmitted: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await verifyOtp().then(
                      (value) => Get.to(
                        () => const OtpScreen(),
                      ),
                    );
                  },
                  child: const Text('Verify'))
            ],
          ),
        ),
      ),
    );
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    listenOtp();
    super.dispose();
  }
}
