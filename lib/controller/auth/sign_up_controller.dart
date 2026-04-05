import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';






abstract class SignUpController extends GetxController {
 void signUp();
  void goToSignIn();
}

class SignUpControllerImp extends SignUpController {
    GlobalKey<FormState> formstate =GlobalKey<FormState>();
  final AuthController controller = Get.find<AuthController>();
  late TextEditingController fullName;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController password;
 

  @override
  void signUp() {
   var formdata = formstate.currentState;
   if(formdata!.validate()){
    controller.signUp(email.text, password.text , fullName.text);
    
 
      
      

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
