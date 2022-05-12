import 'dart:io';
import 'dart:math';

import 'package:chatapp/common/text.dart';
import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/constant.dart';
import 'package:chatapp/controller/password_controller.dart';
import 'package:chatapp/service/email_auth.dart';
import 'package:chatapp/view/auth_screens/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/image_upload.dart';
import '../../controller/loading_controller.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final picker = ImagePicker();
  File? userImage;
  PasswordController passwordController = Get.put(PasswordController());
  LoadingController loadingController = Get.put(LoadingController());

  Future setImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(
        () {
          userImage = File(pickedFile.path);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ts(
                        text: 'Welcome',
                        size: 30,
                        weight: FontWeight.w900,
                      ),
                      Ts(
                        text: 'Create Account To Continue!',
                        size: 20,
                        height: 1.5,
                        weight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          setImage();
                        },
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: 120,
                          width: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: userImage == null
                              ? const Icon(Icons.add)
                              : Image.file(
                                  userImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TsField(
                        hintText: 'UserName',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter UserName';
                          }
                          return null;
                        },
                        controller: userName,
                        prefixIcon: const Icon(Icons.person_outline),
                        hide: false,
                      ),
                      TsField(
                        hintText: 'Email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                        controller: email,
                        prefixIcon: const Icon(Icons.email_outlined),
                        hide: false,
                      ),
                      Obx(
                        () => TsField(
                          hintText: 'Password',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                          controller: password,
                          prefixIcon: const Icon(Icons.lock_outline),
                          icon: passwordController.isShow.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onPress: () {
                            passwordController.isShowing();
                          },
                          hide: passwordController.isShow.value,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () async {
                            await signUpUser();
                          },
                          child: Ts(
                            text: 'SIGN UP',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const LogInScreen(),
                          );
                        },
                        child: Ts(
                          text: 'LOGIN',
                          color: Colors.blue,
                          weight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  signUpUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String? imageUrl =
          await uploaddImage(userImage, '${firebaseAuth.currentUser?.email}');
      EmailAuth.signUp(userName.text, email.text, password.text).then(
        (user) {
          if (user != null) {
            setState(() {
              isLoading = false;
            });
            Get.off(
              () => const HomeScreen(),
            );
            print('SignUp Successful');
          } else {
            print('SignUp Failed');
          }
        },
      ).whenComplete(
        () => collectionReference.doc(firebaseAuth.currentUser!.uid).set(
          {
            'email': email.text,
            'password': password.text,
            'name': userName.text,
            'image': imageUrl,
            'status': 'Unavailable',
          },
        ),
      );
      storage.write('email', email.text);
    }
  }
}
