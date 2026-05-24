import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/core/constant/route.dart';






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
   bool isLoading = false;
 

  @override
  void signUp()async {
   var formdata = formstate.currentState;
   if(formdata!.validate()){
      isLoading = true;
      update();
   bool success =  await  controller.signUp(email.text, password.text , fullName.text);
      await Future.delayed(const Duration(milliseconds: 300));

        isLoading = false;
    update();
       if (success) {
          Get.snackbar(
  "",
  "",
  backgroundColor: Colors.green,
  titleText: const Text(
    "Success",
    style: TextStyle(
      fontSize: 20, // 🔥 حجم العنوان
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  messageText: const Text(
    "Check your email to verify your account 📩",
    style: TextStyle(
      fontSize: 16, // 🔥 حجم النص
      color: Colors.white,
    ),
  ),
);
      Get.offAllNamed(AppRoutes.verifySignup); 
      // أو توديه لصفحة success
    }
     
    
 
      
      

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
