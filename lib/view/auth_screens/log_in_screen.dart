import 'package:chatapp/common/text.dart';
import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/view/auth_screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant.dart';
import '../../controller/loading_controller.dart';
import '../../controller/password_controller.dart';
import '../../service/email_auth.dart';
import '../home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  PasswordController passwordController = Get.put(PasswordController());
  LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => loadingController.isLoad.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ts(
                        text: 'Welcome Back',
                        size: 30,
                        weight: FontWeight.w900,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TsField(
                        hintText: 'Email',
                        validator: (value) {},
                        controller: _email,
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
                          controller: _password,
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
                            await logInUser();
                          },
                          child: Ts(
                            text: 'LOG IN',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const SignUpScreen(),
                          );
                        },
                        child: Ts(
                          text: 'SIGNUP',
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

  logInUser() async {
    if (_formKey.currentState!.validate()) {
      loadingController.isLoadingTrue();
      EmailAuth.logIn(_email.text, _password.text).then(
        (user) {
          if (user != null) {
            loadingController.isLoadingFalse();

            Get.snackbar('Welcome Back', 'How are you?');

            Get.off(
              () => const HomeScreen(),
            );
            print('LogIn Successful');
          } else {
            loadingController.isLoadingFalse();

            Get.snackbar('LogIn Failed', 'Wrong email & password');

            print('LogIn Failed');
          }
        },
      );
      storage.write('email', _email.text);
    }
  }
}
