 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/core/constant/route.dart';
import 'package:salaty/view/auth/fogotPassword/forget_password.dart';
import 'package:salaty/controller/auth/auth_controller.dart';


 abstract  class LoginController extends GetxController {
  

   void login();
   void goToSignUp();
   void goToforgotpassword();
}
class LoginControllerImp extends LoginController{
  GlobalKey<FormState> keystate =GlobalKey<FormState>();
 late TextEditingController email;
late TextEditingController password;
 bool isShowPassword=true;
final AuthController controller = Get.find<AuthController>();


void showPassword(){
  isShowPassword =isShowPassword == true ?false:true;
  update();
}
 @override
  void goToforgotpassword(){
      Get.to(ForgetPassword());

 }

  @override 
  login() {
   var formdata = keystate.currentState;
   if(formdata!.validate()) {
      controller.login(email.text, password.text );
   }

  
    
   
  }
  @override
  goToSignUp() {
Get.toNamed(AppRoutes.signUp );
 
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