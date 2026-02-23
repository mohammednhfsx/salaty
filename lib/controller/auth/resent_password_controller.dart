import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/fogotPassword/Success_ResetPassword.dart';

abstract class ResentPasswordController extends GetxController {
  void Resetpassword();
  void goToSuccessResetPassword();
}

class ResentPasswordControllerImp extends ResentPasswordController {
  late TextEditingController password;
  late TextEditingController repassword;
  @override
  void goToSuccessResetPassword() {
    Get.to(SuccessResetpassword());
  }

  @override
  void Resetpassword() {}
  @override
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
