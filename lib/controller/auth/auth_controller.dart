
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/core/services/notification_service.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;
  bool isAdmin =false;

List<QueryDocumentSnapshot> dataUser=[];
@override
void onInit() {
  getUserData();
  super.onInit();
}

  // ================= SIGN UP =================
  Future<bool> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      userName = name;
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    return false;
  }

  // ================= LOGIN =================
 // ================= LOGIN =================
Future<bool> login(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final bool verified = await checkEmailVerification();

    if (!verified) {
      return false;
    }

    // ننتظر تحميل بيانات المستخدم ومعرفة نوع الحساب
    await getUserData();

    await NotificationService().saveToken();

    update();

    // توجيه المستخدم حسب الصلاحية
   if (isAdmin) {
  Get.offAllNamed(AppRoutes.Admin);
} else {
  Get.offAllNamed(AppRoutes.homepage);
}

    return true;
  } on FirebaseAuthException catch (e) {
    Get.snackbar(
      "Login Error",
      e.message ?? "حدث خطأ أثناء تسجيل الدخول",
    );
    return false;
  } catch (e) {
    Get.snackbar("Error", e.toString());
    return false;
  }
}


  // ================= VERIFY =================
 // ✅ المفروض يرجع bool ويمنع الدخول
Future<bool> checkEmailVerification() async {
  await auth.currentUser!.reload();

  if (!auth.currentUser!.emailVerified) {
    Get.snackbar("Error", "Email not verified ❌");
    await auth.signOut(); // ← يسجل خروج
    return false;
  }

  DocumentSnapshot doc = await firestore
      .collection("users")
      .doc(auth.currentUser!.uid)
      .get();

  if (!doc.exists) {
    await firestore.collection("users").doc(auth.currentUser!.uid).set({
      "email": auth.currentUser!.email,
      "name": userName ?? "No Name",
      "uid": auth.currentUser!.uid,
      "role": auth.currentUser!.email == "abc3dr@gmail.com" ? "admin" : "user",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
  return true;
}


  // ================= LOGOUT =================
  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed("/login");
  }




    // ================= get data user =================

  Future<void> getUserData() async {
  try {
    final User? currentUser = auth.currentUser;

    if (currentUser == null) return;

    final DocumentSnapshot<Map<String, dynamic>> doc = await firestore
        .collection("users")
        .doc(currentUser.uid)
        .get();

    if (!doc.exists) return;

    final Map<String, dynamic>? userData = doc.data();

    if (userData == null) return;

    userName = userData['name'] as String?;
    userEmail = userData['email'] as String?;

    // الأدمن يشاهد لوحة الأدمن فقط
    isAdmin = userData['role'] == 'admin';

    update();
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}

 

}
