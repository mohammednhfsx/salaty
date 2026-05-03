 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/core/constant/route.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/view/auth/fogotPassword/resetpassword.dart';


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
 bool isLoading = false;
final AuthController controller = Get.find<AuthController>();


void showPassword(){
  isShowPassword =isShowPassword == true ?false:true;
  update();
}
 @override
  void goToforgotpassword(){
      Get.to(ForgotPasswordScreen());

 }

  @override 
login() async {
  var formdata = keystate.currentState;

  if (formdata!.validate()) {
    isLoading = true;
    update();

    bool success = await controller.login(
      email.text,
      password.text,
    );

    // نخلي فريم واحد حتى يظهر اللودنك
    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
    update();

    if (success) {
      Get.offAllNamed(AppRoutes.homepage);
    }
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