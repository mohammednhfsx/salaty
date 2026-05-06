// ignore: file_names
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';

class VerifyCodeLoginImp extends GetxController {
  AuthController authcontroller = Get.find();

  Future<void> verifyLogin() async {
    try {
      await authcontroller.auth.currentUser?.reload();

      var user = authcontroller.auth.currentUser;

      if (user != null && user.emailVerified) {
 Get.back(); 
      } 

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}