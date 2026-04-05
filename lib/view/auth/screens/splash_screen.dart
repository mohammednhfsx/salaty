import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salaty/controller/auth/splash_controller.dart';
import 'package:salaty/core/localization/lang/language.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload();

        if (user.emailVerified) {
          Get.offAllNamed("/Homepage");
        } else {
          Get.offAllNamed("/VerifyCodeLogin");
        }

      } else {
        Get.offAll(() =>  Language());
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage("assets/images/logo.jpeg"),
        ),
      ),
    );
  }
}