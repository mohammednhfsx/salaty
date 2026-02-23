import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/screens/success_signup.dart';


abstract class CheckEmailController extends GetxController {
 void checkEmail();
   void goToSuccessSignUp();
 
}

class CheckEmailControllerImp extends CheckEmailController {

  late TextEditingController email;
   @override
  void goToSuccessSignUp(){
    Get.to(SuccessSignup());
   }


  @override
  void checkEmail() {}
  @override
 

  @override
  void onInit() {
  email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}
