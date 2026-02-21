import 'dart:ui';

import 'package:get/get.dart';
import 'package:salaty/core/services/services.dart';

class LocaleController extends GetxController {
  Locale? language;
  Myservices myservices = Get.find();

  void changeLang(String langName) {
    Locale locale = Locale(langName);
    myservices.sharedPreferences.setString("lang", langName);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? sharedPreferenceslang = myservices.sharedPreferences.getString("lang");
    if(sharedPreferenceslang == "ar"){
      language = Locale("ar");
      
    }else if (sharedPreferenceslang == "en"){
         language = Locale("en");
    }
    else {
      language =Locale(Get.deviceLocale!.languageCode);
    }

    super.onInit();
  }
}
