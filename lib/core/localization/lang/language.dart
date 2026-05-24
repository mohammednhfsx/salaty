import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/core/localization/lang/widgets/custom_lang_choose.dart';
import 'package:salaty/core/services/services.dart';
import 'package:salaty/core/theme/colors.dart';
import 'package:salaty/view/auth/screens/login_screen.dart';

// ignore: must_be_immutable
class Language extends GetView<LocaleController> {
   Language({super.key});
  Myservices myservices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset("assets/images/logo.jpeg"),
            ),
            Text(
              "Choose_lang".tr,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 12, 12),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "please_select".tr,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 50),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CustomLangChoose(
                        text: "Ar".tr,
                        isSelected: controller.selectedLang.value == "ar",
                        onPressed: () => controller.changeLang("ar"),
                      ),
                      SizedBox(height: 15),
                      CustomLangChoose(
                        text: "En".tr,
                        isSelected: controller.selectedLang.value == "en",
                        onPressed: () => controller.changeLang("en"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: splash_screenColors),
                onPressed: () {
                  myservices.sharedPreferences.setBool("language",true);
              
                  Get.off(() => LoginScreen());
                },
                child: Text(
                  "Next".tr,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 247, 245, 245),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
