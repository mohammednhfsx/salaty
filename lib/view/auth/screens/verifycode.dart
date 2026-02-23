import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_text_body.dart';
import 'package:salaty/view/auth/widgets/custom_text_title.dart';

// ignore: must_be_immutable
class Verifycode extends GetView<LocaleController> {
  const Verifycode({super.key});
  // ForgotPasswordControllerImp conroller = Get.put(ForgotPasswordControllerImp());

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
              CustomTextTitle(text: "verification_Code".tr),
              

              const SizedBox(height: 5),
              // Enter_your_email_forgot
              CustomTextBody(textbody: "send_you_code_to_the_email".tr),
                const SizedBox(height: 50),
               Center(child: CustomTextTitle(text: "Enter_Code".tr)),

              const SizedBox(height: 50),

              // otp input
              OtpTextField(
                borderRadius: BorderRadius.circular(10),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                alignment: Alignment.center,
                contentPadding: EdgeInsetsGeometry.all(10),
                numberOfFields: 5,
                borderColor: Color.fromARGB(255, 252, 68, 190),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                 
                }, // end onSubmit
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
