import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/verify_code_signup.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/core/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_text_body.dart';
import 'package:salaty/view/auth/widgets/custom_text_title.dart';

// ignore: must_be_immutable
class VerifySignup extends GetView<LocaleController> {
  VerifySignup({super.key});
  VerifyCodeSignupImp conroller = Get.put(VerifyCodeSignupImp());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(     backgroundColor: Colors.white,),
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
              Center(child: CustomTextTitle(text: "verify link of Email".tr)),

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
                          conroller.verify(); },
                        child: Text(
                          "Verify".tr,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),

              // otp input
              // OtpTextField(
              //   borderRadius: BorderRadius.circular(10),
              //   textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   alignment: Alignment.center,
              //   contentPadding: EdgeInsetsGeometry.all(10),
              //   numberOfFields: 5,
              //   borderColor: Color.fromARGB(255, 250, 73, 191),
              //   //set to true to show as box or false to show as dash
              //   showFieldAsBox: true,
              //   //runs when a code is typed in
              //   onCodeChanged: (String code) {
              //     //handle validation or checks here
              //   },
              //   //runs when every textfield is filled
              //   onSubmit: (String verificationCode) {
              //      conroller.goToSuccessSignup();
              //   }, // end onSubmit
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
