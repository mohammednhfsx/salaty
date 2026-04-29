import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/profile_controller.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildUserAvatar(controller.userData['name'] ?? ""),

                      SizedBox(width: 15),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      ),
                    ],
                  );
                }),
              ),
            ),

            const ProfileOptions(),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showLogoutDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Container(
                  height: height * 0.05, // بدل 200
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة في الأعلى لإعطاء طابع بصري
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: Colors.red, size: 40),
              ),
              SizedBox(height: 20),
              Text(
                "تسجيل الخروج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  // زر الإلغاء
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  // زر تسجيل الخروج
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                      child: Text(
                        "خروج",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
