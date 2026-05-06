import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/controller/profiles_controller.dart';
import 'package:salaty/core/functions/avator.dart';
import 'package:salaty/view/screen/profile/profile_options.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(color:   Colors.teal,),
              child: Padding(
                padding: const EdgeInsets.only( top: 45),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildUserAvatar(controller.userData['name'] ?? ""),

                      SizedBox(width: 15),
                       Text(
                            controller.userData['name'] ?? "Loading...",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 2),

                          Text(
                            controller.userData['email'] ?? "",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),

                    
                    ],
                  );
                }),
              ),
            ),

            const ProfileOptions(),
            SizedBox(height: 10),
  ])));}}
