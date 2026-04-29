import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:salaty/models/product_model.dart';

class ProductController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<ProductModel> products = [];
  File? imageFile;
  bool isLoading = false;
  bool isShimmmer=false;

  // ✅ حط الـ API Key تبعك هنا
  final String imgbbApiKey = "c8b8da5673b513d90e323aa002148077";

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }

  // ================= pick image =================
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // ✅ ضغط الصورة
    );
    if (picked != null) {
      imageFile = File(picked.path);
      update();
    }
  }

  // ================= upload to ImgBB =================
  Future<String?> uploadImage(File file) async {
    try {
      String base64Image = base64Encode(await file.readAsBytes());

      var response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload"),
        body: {
          "key": imgbbApiKey,
          "image": base64Image,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['data']['url']; //  رابط الصورة
      }
      return null;
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الصورة: $e");
      return null;
    }
  }

  // ================= GET =================
  Future<void> getProducts() async {
    try {
      isLoading = true;
      isShimmmer=true;
      update();
      var response = await firestore.collection("products").get();
      products = response.docs.map((e) {
        return ProductModel.fromJson(e.data(), e.id);
      }).toList();
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل المنتجات: $e");
    } finally {
      isLoading = false;
      isShimmmer=false;
      update();
    }
  }

  // ================= ADD =================
  Future<void> addProduct({
    required String name,
    required String desc,
    required double price,
  }) async {
    if (imageFile == null) {
      Get.snackbar("خطأ", "اختر صورة أولاً");
      return;
    }

    try {
      isLoading = true;
      update();

      String? imageUrl = await uploadImage(imageFile!);
      if (imageUrl == null) {
        Get.snackbar("خطأ", "فشل رفع الصورة");
        return;
      }

      await firestore.collection("products").add({
        "name": name,
        "description": desc,
        "price": price,
        "image": imageUrl,
      });

      imageFile = null;
      Get.snackbar("نجاح", "تم إضافة المنتج ✅");
      Get.back();
      getProducts();
    } catch (e) {
      Get.snackbar("خطأ", "فشل إضافة المنتج: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // ================= UPDATE =================
  Future<void> updateProduct({
    required String id,
    required String name,
    required String desc,
    required double price,
    required String oldImageUrl,
  }) async {
    try {
      isLoading = true;
      update();

      String imageUrl;

      if (imageFile != null) {
        String? newUrl = await uploadImage(imageFile!);
        if (newUrl == null) {
          Get.snackbar("خطأ", "فشل رفع الصورة");
          return;
        }
        imageUrl = newUrl;
      } else {
        imageUrl = oldImageUrl;
      }

      await firestore.collection("products").doc(id).update({
        "name": name,
        "description": desc,
        "price": price,
        "image": imageUrl,
      });

      imageFile = null;
      Get.snackbar("نجاح", "تم تعديل المنتج ✅");
      Get.back();
      getProducts();
    } catch (e) {
      Get.snackbar("خطأ", "فشل تعديل المنتج: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // ================= DELETE =================
  Future<void> deleteProduct(String id) async {
    try {
      await firestore.collection("products").doc(id).delete();
      Get.snackbar("نجاح", "تم حذف المنتج ✅");
      getProducts();
    } catch (e) {
      Get.snackbar("خطأ", "فشل حذف المنتج: $e");
    }
  }
}
