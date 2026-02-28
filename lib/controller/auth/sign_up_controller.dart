import 'package:flutter/material.dart';
import 'package:get/get.dart';





abstract class SignUpController extends GetxController {
 void signUp();
  void goToSignIn();
}

class SignUpControllerImp extends SignUpController {
    GlobalKey<FormState> formstate =GlobalKey<FormState>();
  late TextEditingController fullName;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void signUp() {
   var formdata = formstate.currentState;
   if(formdata!.validate()){
      

   }
  }
  @override
  void goToSignIn() {
     Get.back();
  
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
