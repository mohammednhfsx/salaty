

import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/view/auth/screens/success_signup.dart';



abstract class VerifyCodeSignup extends GetxController {
  void verify();
  void goToSuccessSignup();
}

class VerifyCodeSignupImp extends VerifyCodeSignup {
  AuthController authcontroller =Get.find();
  late String verifycode;

  @override
  void goToSuccessSignup() {
    Get.to((SuccessSignup()));
  }

  @override
  void verify() {
  Get.find<AuthController>().checkEmailVerification();
  // Get.to(SuccessSignup());
  }



}
