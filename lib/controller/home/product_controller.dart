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
  List<File?> imageFiles = [null, null, null];
  bool isLoading = false;
  bool isShimmmer = false;

  final List<String> categoryList = [
    'Mobile',
    'Home',
    'Accessories',
    'Pc',
    'Laptop',
    'Other',
  ];

  String selectedCategory = 'All';

  final String imgbbApiKey = "c8b8da5673b513d90e323aa002148077";

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }

  // ================= Category =================
  void setCategory(String cat) {
    selectedCategory = cat;
    update();
  }

  List<ProductModel> get filteredProducts {
    if (selectedCategory == 'All') return products;
    return products.where((p) => p.category == selectedCategory).toList();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    update();
  }

  // ================= Pick Image =================
  Future<void> pickImage(int index) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      imageFiles[index] = File(picked.path);
      update();
    }
  }

  // ================= Upload Single Image to ImgBB =================
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
        return jsonData['data']['url'];
      }
      return null;
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الصورة: $e");
      return null;
    }
  }

  // ================= Upload All Images =================
  Future<List<String>> uploadImages() async {
    List<String> urls = [];
    for (var file in imageFiles) {
      if (file != null) {
        String? url = await uploadImage(file);
        if (url != null) urls.add(url);
      }
    }
    return urls;
  }

  // ================= GET =================
  Future<void> getProducts() async {
    try {
      isLoading = true;
      isShimmmer = true;
      update();
      var response = await firestore.collection("products").get();
      products = response.docs.map((e) {
        return ProductModel.fromJson(e.data(), e.id);
      }).toList();
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل المنتجات: $e");
    } finally {
      isLoading = false;
      isShimmmer = false;
      update();
    }
  }

  // ================= ADD =================
  Future<void> addProduct({
    required String name,
    required String desc,
    required double price,
    required String category,
  }) async {
    if (imageFiles.every((f) => f == null)) {
      Get.snackbar("خطأ", "اختر صورة واحدة على الأقل");
      return;
    }
    try {
      isLoading = true;
      update();

      List<String> imageUrls = await uploadImages();
      if (imageUrls.isEmpty) {
        Get.snackbar("خطأ", "فشل رفع الصور");
        return;
      }

      await firestore.collection("products").add({
        "name": name,
        "description": desc,
        "price": price,
        "category": category,
        "images": imageUrls,
        "image": imageUrls.first,
      });

      imageFiles = [null, null, null];
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
    required List<String> oldImages,
    required String category,
  }) async {
    try {
      isLoading = true;
      update();

      List<String> finalImages = [];
      for (int i = 0; i < 3; i++) {
        if (imageFiles[i] != null) {
          String? url = await uploadImage(imageFiles[i]!);
          if (url != null) finalImages.add(url);
        } else if (i < oldImages.length) {
          finalImages.add(oldImages[i]);
        }
      }

      await firestore.collection("products").doc(id).update({
        "name": name,
        "description": desc,
        "price": price,
        "category": category,
        "images": finalImages,
        "image": finalImages.isNotEmpty ? finalImages.first : '',
      });

      imageFiles = [null, null, null];
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