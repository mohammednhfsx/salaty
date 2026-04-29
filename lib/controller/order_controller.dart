import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/models/order_model.dart';

class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
   
    if (uid != null) {
      getMyOrders();
    } else {
     
    }
  }

  // ================= إنشاء طلب =================
  Future<void> placeOrder(CartController cart) async {
 

    if (uid == null) {
      Get.snackbar("خطأ", "يجب تسجيل الدخول أولاً");
      return;
    }

    if (cart.cartItems.isEmpty) {
      Get.snackbar("خطأ", "السلة فارغة");
      return;
    }

    try {
      isLoading.value = true;

     

      OrderModel newOrder = OrderModel(
        userId: uid!,
        items: cart.cartItems.toList(),
        total: cart.finaltotal,
        status: 'pending',
        createdAt: DateTime.now(),
      );

   
      DocumentReference ref =
          await firestore.collection('orders').add(newOrder.toJson());
     

      await cart.clearCart();
     

      await getMyOrders();
     

      Get.snackbar(
        "تم الطلب ✅",
        "سيتم التواصل معك قريباً",
        backgroundColor: const Color(0xFF0F6E56),
        colorText: const Color(0xFFE1F5EE),
        duration: const Duration(seconds: 3),
      );

      Get.offNamed(AppRoutes.orders);
    } catch (e) {
      print("❌ placeOrder ERROR: $e");
      Get.snackbar("خطأ", "فشل إرسال الطلب: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= جلب طلبات المستخدم =================
  Future<void> getMyOrders() async {
    if (uid == null) return;
    print("🟡 getMyOrders — uid: $uid");
    try {
      isLoading.value = true;
      var snap = await firestore
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      print("✅ docs found: ${snap.docs.length}");
      orders.value =
          snap.docs.map((e) => OrderModel.fromJson(e.data(), e.id)).toList();
    } catch (e) {
      print("❌ getMyOrders ERROR: $e");
      Get.snackbar("خطأ", "فشل تحميل الطلبات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= كل الطلبات للأدمن =================
  Future<void> getAllOrders() async {
    try {
      isLoading.value = true;
      var snap = await firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      orders.value =
          snap.docs.map((e) => OrderModel.fromJson(e.data(), e.id)).toList();
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= تحديث حالة الطلب =================
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      int index = orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        orders[index] = orders[index].copyWith(status: newStatus);
        orders.refresh();
      }
      Get.snackbar("تم", "تم تحديث حالة الطلب ✅");
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    }
  }
}