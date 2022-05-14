import 'package:get/get.dart';

class ModController extends GetxController {
  var isChange = false.obs;
  isChangeMode(value) {
    isChange.value = value;
  }
}
