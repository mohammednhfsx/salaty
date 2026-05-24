import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/view/auth/fogotPassword/success_resetpassword.dart';

abstract class ResentPasswordController extends GetxController {
  late TextEditingController email;
   resetPassword();
   goToSuccessResetPassword();
}

class ResentPasswordControllerImp extends ResentPasswordController {
  late TextEditingController password;
  late TextEditingController repassword;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController email;
  RxBool isLoading = false.obs;
  @override
  void goToSuccessResetPassword() {
    Get.to(SuccessResetpassword());
  }

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
  
  @override
   resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );

      Get.snackbar(
        "✅ تم الإرسال",
        "راجع بريدك الإلكتروني لإعادة تعيين كلمة المرور",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // انتقل لشاشة النجاح أو رجّع للـ Login
      Get.offNamed(AppRoutes.successResetpassword);

    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      Get.snackbar(
        "❌ خطأ",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'هذا الإيميل غير مسجل';
      case 'invalid-email':
        return 'صيغة الإيميل غير صحيحة';
      case 'too-many-requests':
        return 'حاولت كثيراً، انتظر قليلاً';
      default:
        return 'حدث خطأ، حاول مرة ثانية';
    }
  }
  
 
}
  

