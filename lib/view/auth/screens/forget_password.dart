import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/forgot_password_controller.dart';

import 'package:salaty/core/localization/local_change.dart';

import 'package:salaty/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_text_body.dart';
import 'package:salaty/view/auth/widgets/custom_text_lable.dart';
import 'package:salaty/view/auth/widgets/custom_text_title.dart';
import 'package:salaty/view/auth/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class ForgetPassword extends GetView<LocaleController> {
  ForgetPassword({super.key});
  ForgotPasswordControllerImp conroller = Get.put(ForgotPasswordControllerImp());

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
              CustomTextTitle(text: "Forgot_Password".tr),

              const SizedBox(height: 5),
              // Enter_your_email_forgot
              CustomTextBody(textbody: "Enter_your_email_forgot".tr),

              const SizedBox(height: 50),
              //  Email
              CustomTextLable(textLable: "Email_or_phone".tr),

              const SizedBox(height: 8),
              CustomTextfield(
                controllertextfield: conroller.email,
                hintText: "Enter_your_email_or_phone".tr,
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
                  onPressed: () {},
                  child: Text(
                    "check".tr,
                    style: TextStyle(color: Colors.white,fontSize: 20),
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
