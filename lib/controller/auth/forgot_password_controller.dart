import 'package:flutter/material.dart';
import 'package:get/get.dart';


abstract class ForgotPasswordController extends GetxController {
 void checkEmail();
 
}

class ForgotPasswordControllerImp extends ForgotPasswordController {

  late TextEditingController email;


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
