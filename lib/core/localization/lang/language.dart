import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/core/localization/lang/widgets/custom_lang_choose.dart';

import 'package:salaty/view/auth/screens/login_screen.dart';

class Language extends GetView<LocaleController>{

   const Language({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text(
            "Choose_lang".tr,
              style: TextStyle(fontSize: 25, color: const Color.fromARGB(255, 14, 12, 12)),
            ),
             SizedBox(height: 200,width: 200,
              child: Lottie.asset('assets/lottile/lottile.json')),


            SizedBox(height: 100),
          Obx(() => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    CustomLangChoose(
      text: "Ar".tr,
      isSelected: controller.selectedLang.value == "ar",
      onPressed: () => controller.changeLang("ar"),
    ),
    SizedBox(width: 25),
    CustomLangChoose(
      text: "En".tr,
      isSelected: controller.selectedLang.value == "en",
      onPressed: () => controller.changeLang("en"),
    ),
  ],
)),
            SizedBox(height: 200),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,),
              onPressed: () {
                Get.off(()=>LoginScreen());
              },
              child: Text(
                "Next".tr,
                style: TextStyle(
                  color: const Color.fromARGB(255, 247, 245, 245),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

             
          ],
        ),
      ),
    );
  }
}
