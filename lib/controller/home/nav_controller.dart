
import 'package:get/get.dart';

// ignore: camel_case_types
class navController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}