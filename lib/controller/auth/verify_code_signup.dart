

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
   var isLoading = false.obs;

  @override
  void goToSuccessSignup() {
    Get.to((SuccessSignup()));
  }

  @override
  Future<void> verify()async {
    try{
      isLoading.value=true;

      bool verified = await authcontroller.checkEmailVerification();
       if(verified){
        goToSuccessSignup();
       }
       



    }catch(e){
        Get.snackbar("خطأ", e.toString());
    }
     finally {
      isLoading.value = false;
    }
 
  }



}
