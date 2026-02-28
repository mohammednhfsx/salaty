

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/core/services/services.dart';

class Mymiddleware extends GetMiddleware{
  // ignore: non_constant_identifier_names
  int? get Priority => 1;


Myservices myservices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if(myservices.sharedPreferences.getBool("language")== true) {
      return  RouteSettings(name: AppRoutes.login);
    }
    return null;
  }


}