import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoad = false.obs;
  isLoadingTrue() {
    isLoad.value = true;
  }

  isLoadingFalse() {
    isLoad.value = false;
  }
}
