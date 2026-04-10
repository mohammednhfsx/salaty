import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salaty/core/constant/route.dart';


class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth.authStateChanges().listen((User? user) {
     
        if (user == null) {
          print("============================User is signed out");
          Get.offAllNamed("/login");
        } else {
         if (user.emailVerified) {
      Get.offAllNamed(AppRoutes.homepage);
    } else {
      Get.offAllNamed(AppRoutes.verifySignup);
    }
   
        }
      });
    });
  }

  // ================= SIGN UP =================
  Future<void> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      userName = name;
    

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ================= LOGIN =================
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //  Get.offAllNamed("/Homepage");
      // final user = FirebaseAuth.instance.currentUser;
      // await user?.reload();

      // if (user != null && user.emailVerified) {
      //   Get.offAllNamed(AppRoutes.homepage);
      // } else {
      //   Get.toNamed(AppRoutes.verifyCodeLogin);
      // }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ================= VERIFY =================
  Future<void> checkEmailVerification() async {
    await auth.currentUser!.reload();

    if (auth.currentUser!.emailVerified) {
      // 🔥 تحقق إذا المستخدم موجود أصلاً
      DocumentSnapshot doc = await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get();

      if (!doc.exists) {
        // 🔥 أضف المستخدم مرة وحدة فقط
        await firestore.collection("users").doc(auth.currentUser!.uid).set({
          "email": auth.currentUser!.email,
          "name": userName ?? "No Name",
          "uid": auth.currentUser!.uid,
          "createdAt": FieldValue.serverTimestamp(),
        });
        
      }

    } else {
      Get.snackbar("Error", "Email not verified ❌");
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await auth.signOut();
    // Get.offAllNamed("/login");
  }
}
