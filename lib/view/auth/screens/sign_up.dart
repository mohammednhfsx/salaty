import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/controller/auth/sign_up_controller.dart';
import 'package:salaty/core/functions/validinput.dart';

import 'package:salaty/core/theme/colors.dart';
import 'package:salaty/view/auth/widgets/custom_textfield.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key}) {
    Get.lazyPut(() => SignUpControllerImp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: GetBuilder<SignUpControllerImp>(
          builder: (controllerImp) {
            return Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: controllerImp.formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create_Account".tr,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sign_up_to_start_shopping".tr,
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    SizedBox(height: 50),

                    //fullname
                    Text(
                      "Full_Name".tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextFormfield(
                      hintText: "Enter_your_Full_name".tr,
                      prefixIcon: Icons.person_outlined,
                      controllertextfield: controllerImp.fullName,
                      valid: (val) {
                        return validInput(val!, "userName", 3, 10);
                      },
                    ),

                    SizedBox(height: 20),
                    //Email
                    Text(
                      "Email_or_phone".tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextFormfield(
                      hintText: "Enter_your_email_or_phone".tr,
                      prefixIcon: Icons.person_outlined,
                      controllertextfield: controllerImp.email,
                      valid: (val) {
                        return validInput(val!, "email", 3, 50);
                      },
                    ),

                    SizedBox(height: 20),

                    //password
                    Text(
                      "password".tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormfield(
                      hintText: "Enter_your_password".tr,

                      prefixIcon: Icons.person_outlined,
                      controllertextfield: controllerImp.password,
                      valid: (val) {
                        return validInput(val!, "password", 5, 12);
                      },
                    ),

                    SizedBox(height: 20),

                    //Confrim password
                    // Text(
                    //   "Confrim_password".tr,
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: "Enter_your_Confrim_password".tr,

                    //     prefixIcon: const Icon(Icons.lock_outline),
                    //     suffixIcon: const Icon(Icons.visibility_outlined),
                    //     filled: true,
                    //     fillColor: Color(0xfff1f5f9),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: const BorderSide(color: Colors.blue, width: 2),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    // ),

                    //==============================================================
                    //button sign up
                    //==============================================================
                  SizedBox(
  width: double.infinity,
  height: 50,
  child: GetBuilder<SignUpControllerImp>(
    builder: (controller) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: splash_screenColors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: controller.isLoading
          ? null
          : () {
              controller.signUp();
            },
      child: controller.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              "Create_Account".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
    ),
  ),
),
                    //=====================================
                    //Alreadyaccount
                    //=================================
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already_have_an_account".tr),
                          GestureDetector(
                            onTap: () {
                              controllerImp.goToSignIn();
                            },
                            child: Text(
                              "Sign_in".tr,
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
            );
          },
        ),
      ),
    );
  }
}
