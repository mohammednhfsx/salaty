
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
 Future<bool> login(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    
    bool verified = await checkEmailVerification();
    if (!verified) return false; // ← لا يدخل إذا ما أكد
    
    await getUserData();
     NotificationService().saveToken();
    update();
    
    return true;
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
    if (auth.currentUser == null) return;

    String uid = auth.currentUser!.uid;

    DocumentSnapshot doc =
        await firestore.collection("users").doc(uid).get();

    if (doc.exists) {
      userName = doc['name'];
      userEmail = doc['email'];

      if(doc['role']=='admin'){
        isAdmin=true;
      }else{isAdmin=false;}
      update();
    }
  } catch (e) {
    Future.delayed(Duration(milliseconds: 300), () {
      Get.snackbar("Error", e.toString());
    });
  }
}

 

}
