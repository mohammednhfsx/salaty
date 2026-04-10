import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/core/widgets/profile_options%20.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
       AuthController controller =      Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "assets/images/WhatsApp Image 2026-02-17 at 3.30.21 PM.jpeg",
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "John Doe",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "john.doe@email.com",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "+1 (555) 123-4567",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
         

              const ProfileOptions(),
              SizedBox(height: 10,),
              InkWell(onTap: () {
                 controller.logout();
              },
                child: Container(height: 50,width: 400,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.red),alignment:AlignmentGeometry.center ,
                  child: Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
              )
          ],
        ),
      ),
    );
  }
}
