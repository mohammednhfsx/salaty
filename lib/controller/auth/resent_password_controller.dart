import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/fogotPassword/success_resetpassword.dart';

abstract class ResentPasswordController extends GetxController {
  void resetpassword();
  void goToSuccessResetPassword();
}

class ResentPasswordControllerImp extends ResentPasswordController {
  late TextEditingController password;
  late TextEditingController repassword;
 final GlobalKey<FormState> key  = GlobalKey<FormState>();
  @override
  void goToSuccessResetPassword() {
    Get.to(SuccessResetpassword());
  }

  @override
  void resetpassword() {
var formdata = key.currentState;
   if(formdata!.validate()) {}}
  
  @override
  void onInit() {
    password = TextEditingController();
    repassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }
}
