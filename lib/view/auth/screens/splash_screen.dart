
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     Timer(const Duration(seconds: 3), () {
        final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offNamed("/login");
    } else {
      Get.offNamed("/homepage");
    }});
   
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage("assets/images/WhatsApp Image 2026-04-28 at 9.13.17 PM.png"),
        ),
      ),
    );
  }
}