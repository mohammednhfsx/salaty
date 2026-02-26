
import 'package:get/get.dart';
import 'package:salaty/view/auth/screens/success_signup.dart';



abstract class VerifyCodeSignup extends GetxController {
  void checkCode();
  void goToSuccessSignup();
}

class VerifyCodeSignupImp extends VerifyCodeSignup {
  late String verifycode;

  @override
  void goToSuccessSignup() {
    Get.to((SuccessSignup()));
  }

  @override
  void checkCode() {}



}
