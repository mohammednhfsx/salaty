import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/models/product_model.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;
  var isLoading = false.obs;
  var products = <ProductModel>[].obs;
  var addresses = <Map <String ,dynamic>>[].obs;
  var appVersion = ''.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ✅ nullable — لا crash لو المستخدم مو مسجّل
  String? get userid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    if (userid != null) getUserData();
      _getAppVersion();
  }








Future<void> _getAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  appVersion.value = info.version;
}




   // =================  إضافة عنوان =================

Future <void> addAddress({
  required String label,
  required String city,
  required String address,
  required String phone,
})  async {

  if(userid==null)return;

  try{
    await firestore.collection('users').doc(userid).collection('addresses').add(
      {
        'label':label,
        'city':city,
        'address':address,
        'phone':phone,
        'createdAt':FieldValue.serverTimestamp(),
      }
      
    ) ;
      Get.snackbar("تم ✅", "تم إضافة العنوان");
       await getAddresses();
  } catch(e){  Get.snackbar("خطأ", "فشل إضافة العنوان: $e");}



}


// =============== حذف عنوان ===================


Future<void> deleteAddress(String addressId) async {
  if (userid == null) return;
  try {
    await firestore
        .collection('users')
        .doc(userid)
        .collection('addresses')
        .doc(addressId)
        .delete();
    await getAddresses();
    Get.snackbar("تم ✅", "تم حذف العنوان");
  } catch (e) {
    Get.snackbar("خطأ", "فشل الحذف: $e");
  }
}


// =============== جلب العناوين  ===========
Future<void> getAddresses() async{
    if (userid == null) return;
    try{
      var snap = await firestore.collection('users').doc(userid).collection('addresses').get();
      addresses.value = snap.docs.map((d)=>{'id':d.id , ...d.data()}).toList();





    }
    
    
    catch(e){
        Get.snackbar("خطأ", "فشل تحميل العناوين: $e");
    }


}











 

  // ================= جلب البيانات =================
   Future<void> getUserData() async {
    if (userid == null) return;
    try {
      isLoading.value = true;
      var doc = await firestore.collection('users').doc(userid).get();
      if (doc.exists) userData.value = doc.data()!;
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل البيانات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= تحديث الاسم =================
  Future<void> updateName(String newName) async {
    if (userid == null) return;
    if (newName.trim().isEmpty) {
      Get.snackbar("خطأ", "الاسم لا يمكن أن يكون فارغاً");
      return;
    }
    try {
      isLoading.value = true;

      // 1: نحدّث Firestore
      await firestore.collection('users').doc(userid).update({
        'name': newName.trim(),
      });

      // 2: نحدّث البيانات المحلية فوراً بدون ما نرجع للسيرفر
      userData['name'] = newName.trim(); 
      userData.refresh();

      // 3: نحدّث AuthController حتى يظهر الاسم الجديد في الـ Home
      await Get.find<AuthController>().getUserData();

      Get.snackbar("تم ✅", "تم تحديث الاسم بنجاح",
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          colorText: const Color.fromARGB(255, 14, 13, 13));
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحديث: $e");
    } finally {
      isLoading.value = false;
    }
  }
}