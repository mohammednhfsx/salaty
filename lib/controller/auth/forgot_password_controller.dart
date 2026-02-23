import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/fogotPassword/verifycode.dart';


abstract class ForgotPasswordController extends GetxController {
 void checkEmail();
   void goToverifycode();
 
}

class ForgotPasswordControllerImp extends ForgotPasswordController {

  late TextEditingController email;
   @override
  void goToverifycode(){
    Get.to(Verifycode());
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
