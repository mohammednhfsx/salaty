import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salaty/core/constant/route.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } 
    else if (!user.emailVerified) {
      Get.offAllNamed(AppRoutes.verifyCodeLogin);
    } 
    else {
      // Get.offAllNamed(AppRoutes.homepage);
    }
  }
}