import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  var userData = {}.obs;
  var isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  
  String? get userid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
  
    if (userid != null) {
      getUserData();
    }
  }

  // ================= جلب بيانات المستخدم =================
  Future<void> getUserData() async {
  
    if (userid == null) return;

    try {
      isLoading.value = true;

      var doc = await firestore.collection('users').doc(userid).get();

     
      if (doc.exists) {
        userData.value = doc.data()!;
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل البيانات: $e");
    } finally {
      isLoading.value = false;
    }
  }

 
  Future<void> updateName(String newName) async {
    if (userid == null) return;
    if (newName.trim().isEmpty) {
      Get.snackbar("خطأ", "الاسم لا يمكن أن يكون فارغاً");
      return;
    }

    try {
      isLoading.value = true;

   
      await firestore.collection('users').doc(userid).update({
        'name': newName.trim(),
      });

   
      await Get.find<dynamic>().getUserData();

      //  نحدّث البيانات المحلية
      userData['name'] = newName.trim();
      userData.refresh();

      Get.snackbar("نجاح", "تم تحديث الاسم ✅");
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحديث: $e");
    } finally {
      isLoading.value = false;
    }
  }
}