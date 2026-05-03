

import 'package:get/get.dart';
import 'package:salaty/view/auth/fogotPassword/resetpassword.dart';

abstract class VerifyCodeController extends GetxController {
  void checkCode();
  void goT0ResetPassword(); 
}

class VerifyCodeControllerImp extends VerifyCodeController {

  late String verifycode;
  

  @override
  void goT0ResetPassword() {
    Get.to(ForgotPasswordScreen()); 
  }

  @override
  void checkCode() {
 
  }



}
