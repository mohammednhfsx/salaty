
import 'package:get/get.dart';
import 'package:salaty/core/constant/route.dart';





abstract class SuccessControllerSignup extends GetxController {
 
  void goToLogin();
}

class SuccessControllerSignupImp extends SuccessControllerSignup {
  late String verifycode;

  @override
  void goToLogin() {
  Get.offAllNamed(AppRoutes.homepage);
  }





}
