import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/view/auth/screens/verify_code_signup.dart';


abstract class CheckEmailController extends GetxController {
 void checkEmail();
   void goToVerifySignup();
 
}

class CheckEmailControllerImp extends CheckEmailController {

  late TextEditingController email;
  GlobalKey<FormState> keystate =GlobalKey<FormState>();
   @override
  void goToVerifySignup(){
    Get.to(VerifySignup());
   }


  @override
  void checkEmail() {
    var dataform = keystate.currentState;
    if(dataform!.validate()) {}
  }
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
