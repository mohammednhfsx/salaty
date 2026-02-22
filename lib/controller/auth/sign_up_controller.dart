import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/auth/screens/login_screen.dart';

abstract class SignUpController extends GetxController {
 void signUp();
  void goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  late TextEditingController fullName;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void signUp() {}
  @override
  goToSignIn() {
    Get.to(LoginScreen());
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    fullName = TextEditingController();
    phone = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    fullName.dispose();
    phone.dispose();
    super.dispose();
  }
}
