import 'package:chatapp/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  static Future<User?> signUp(
      String name, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print('SignUp Successful');
        user.updateProfile(displayName: name);
        return user;
      } else {
        print('SignUp Faild');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> logIn(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print('logIn Successful');

        return user;
      } else {
        print('LogIn Faild');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future logOut() async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
