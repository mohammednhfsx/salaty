import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/resent_password_controller.dart';

import 'package:salaty/core/localization/local_change.dart';

import 'package:salaty/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_text_body.dart';
import 'package:salaty/view/auth/widgets/custom_text_lable.dart';
import 'package:salaty/view/auth/widgets/custom_text_title.dart';
import 'package:salaty/view/auth/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class Resetpassword extends GetView<LocaleController> {
  Resetpassword({super.key});
  ResentPasswordControllerImp conroller = Get.put(
    ResentPasswordControllerImp(),
  );

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

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Forgot_Password
              CustomTextTitle(text: "Reset_Password".tr),

              const SizedBox(height: 5),
              // Enter_your_email_forgot
              CustomTextBody(textbody: "Enter_your_email_forgot".tr),

              const SizedBox(height: 50),
              //  Email
              CustomTextLable(textLable: "new_password".tr),

              const SizedBox(height: 8),
              CustomTextfield(
                controllertextfield: conroller.password,
                hintText: "Enter_new_password".tr,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 40),
              CustomTextLable(textLable: "Confrim_password".tr),
              const SizedBox(height: 8),

              CustomTextfield(
                controllertextfield: conroller.repassword,
                hintText: "Enter_your_Confrim_password".tr,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 50),

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
                    conroller.goToSuccessResetPassword();
                  },
                  child: Text(
                    "check".tr,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
