import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoad = false.obs;
  isLoading() {
    isLoad.value = !isLoad.value;
  }
}
