import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/core/constant/route.dart';
import 'package:salaty/view/screen/nav_page.dart';

class Mymiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {

    final user = FirebaseAuth.instance.currentUser;

    // إذا ما مسجل دخول
    if (user == null) {
      return const RouteSettings(name: AppRoutes.login);
    }else{
      HomePage();
    }

  //   // إذا مسجل بس مو مفعل الإيميل
  //   if (!user.emailVerified) {
  //     return const RouteSettings(name: AppRoutes.verifyCodeLogin);
  //   }


  //   return null;
  // }
}}