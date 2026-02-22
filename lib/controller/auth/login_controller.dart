 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/screens/forget_password.dart';
import 'package:salaty/view/auth/screens/sign_up.dart';

 abstract  class LoginController extends GetxController {
  

   void login();
   void goToSignUp();
    void goToforgotpassword();
}
class LoginControllerImp extends LoginController{
 late TextEditingController email;
late TextEditingController password;
 void goToforgotpassword(){
      Get.to(ForgetPassword());

 }

  @override
  login() {
    
   
  }
  @override
  goToSignUp() {
    Get.to(SignUp());
 
  }   
  @override
  void onInit() {
   email=TextEditingController();
   password=TextEditingController();
    super.onInit();
  }
  @override
  void dispose() {
  email.dispose();
  password.dispose();
    super.dispose();
  }
  
}