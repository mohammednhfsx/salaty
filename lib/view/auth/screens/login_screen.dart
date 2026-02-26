import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/login_controller.dart';
import 'package:salaty/core/functions/validinput.dart';
import 'package:salaty/core/localization/local_change.dart';


import 'package:salaty/core/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_text_body.dart';
import 'package:salaty/view/auth/widgets/custom_text_lable.dart';
import 'package:salaty/view/auth/widgets/custom_text_title.dart';
import 'package:salaty/view/auth/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<LocaleController> {
   LoginScreen({super.key});
  LoginControllerImp conroller = Get.put(LoginControllerImp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(30),

          child: Form(key:conroller.keystate ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Welcome Back
                CustomTextTitle(text: "Welcome_Back".tr),
            
                const SizedBox(height: 5),
                // Sign in to continue shopping
                CustomTextBody(textbody: "Sign_in_to_continue_shopping".tr),
            
                const SizedBox(height: 50),
                //  Email
                CustomTextLable(textLable: "Email_or_phone".tr),
            
                const SizedBox(height: 8),
                CustomTextFormfield(controllertextfield: conroller.email,
                valid: (val) {
                   return validInput(val!, "email", 3, 50);
                  
                },
                  hintText: "Enter_your_email_or_phone".tr,
                  prefixIcon: Icons.email_outlined,
                ),
            
                const SizedBox(height: 20),
                //password
                CustomTextLable(textLable: "password".tr),
            
                const SizedBox(height: 8),
                CustomTextFormfield(controllertextfield: conroller.password,
                  valid: (val) {
                    return validInput(val!, "password", 5, 12);
                  
                },
                  hintText: "Enter_your_password".tr,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: Icons.visibility_outlined,
                ),
            
                //forget password
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: TextButton(
                    onPressed: () {
                      conroller.goToforgotpassword();
                    },
                    child: Text(
                      "Forget_password".tr,
                      style: TextStyle(color: splash_screenColors),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: splash_screenColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      conroller.login();
                    },
                    child: Text(
                      "Sign_in".tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
            
                /// Sign up
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't_have_an_account?".tr),
                      GestureDetector(
                        onTap: () {
                          conroller.goToSignUp();
                        },
                        child: Text(
                          "Sign_Up".tr,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
