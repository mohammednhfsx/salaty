import 'package:flutter/material.dart';

import 'package:get/utils.dart';
import 'package:lottie/lottie.dart';

import 'package:salaty/theme/colors.dart';

class SuccessSignup extends StatelessWidget {
  SuccessSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),

          child: Column(
            children: [
              Lottie.asset('assets/lottile/Animation - 1750728441806.json'),
              SizedBox(height: 10),
              Text("Success".tr, style: TextStyle(fontSize: 30)),
              Text(
                "The operation was successful.".tr,
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),

              Spacer(),
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
                    //  controller.signUp();
                  },
                  child: Text(
                    "Go to Login".tr,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
