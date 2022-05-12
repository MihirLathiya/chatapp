import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isShow = true.obs;
  isShowing() {
    isShow.value = !isShow.value;
  }
}
