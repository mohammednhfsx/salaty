import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;

  // ================= SIGN UP =================
  Future<void> signUp(String email, String password, String name) async {
    try {
   UserCredential userCredential =
    await auth.createUserWithEmailAndPassword(
  email: email,
  password: password,
);



await userCredential.user!.sendEmailVerification();
     userName = name;
Get.toNamed("/verifySignup");

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

    // final user = FirebaseAuth.instance.currentUser;
    // await user?.reload();

    // if (user != null && user.emailVerified) {
    //   Get.offAllNamed("/Homepage");
    // } else {
    //   Get.toNamed("/VerifyCodeLogin");
    // }

  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}

  // ================= VERIFY =================
 Future<void> checkEmailVerification() async {
  await auth.currentUser!.reload();

  if (auth.currentUser!.emailVerified) {



   await firestore.collection("users").doc(auth.currentUser!.uid).set({
  "email": auth.currentUser!.email,
  "name": userName, // بدل data["name"]
  "uid": auth.currentUser!.uid,
  "createdAt": DateTime.now(),
});

  Get.offAllNamed("/Homepage");

  } else {
    Get.snackbar("Error", "Email not verified ❌");
  }
}

  // ================= LOGOUT =================
  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed("/login");
  }
}