import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/core/localization/lang/local_change.dart';
import 'package:salaty/core/localization/lang/widgets/custom_lang_choose.dart';
import 'package:salaty/theme/colors.dart';
import 'package:salaty/view/auth/screens/login_screen.dart';

class Language extends GetView<LocaleController>{
  const Language({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splash_screenColors,
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text(
            "Choose_lang".tr,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLangChoose(text: "En".tr,onPressed: () {
                  controller.changeLang("en");
                  
                },), 
                SizedBox(width: 25),
                CustomLangChoose(text: "Ar".tr , onPressed: () {
                                    controller.changeLang("ar");
                  
                },      ),
              ],
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                "Next".tr,
                style: TextStyle(
                  color: Colors.black,
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
