import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/core/services/notification_service.dart';
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
    }
  }

  // ================= إنشاء طلب =================
  Future<void> placeOrder(
    CartController cart, {
    required String name,
    required String phone,
    required String address,
    required String city,
    required String paymentMethod,
  }) async {
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
      final double platformFee =
          double.parse((cart.finaltotal * 0.01).toStringAsFixed(0));

      OrderModel newOrder = OrderModel(
        userId: uid!,
        customerName: name,
        phone: phone,
        address: address,
        city: city,
        paymentMethod: paymentMethod,
        items: cart.cartItems.toList(),
        total: cart.finaltotal,
        status: 'pending',
        createdAt: DateTime.now(),
        platformFee: platformFee,
      );

      await firestore.collection('orders').add(newOrder.toJson());

      await cart.clearCart();
      await getMyOrders();

      await NotificationService().notifyAdmins(
        title: '🛍️ طلب جديد!',
        body: 'وصل طلب جديد من $name — ${cart.cartItems.length} منتج',
      );

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
    try {
      isLoading.value = true;
      var snap = await firestore
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
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
      await firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });

      final order = orders.firstWhere((o) => o.id == orderId);
      final userDoc =
          await firestore.collection('users').doc(order.userId).get();
      final token = userDoc.data()?['fcmToken'];

      final messages = {
        'confirmed': (
          title: '✅ تم تأكيد طلبك!',
          body:
              'طلبك رقم #${orderId.substring(0, 8).toUpperCase()} تم تأكيده وسيصلك قريباً',
        ),
        'delivered': (
          title: '🎉 وصل طلبك!',
          body:
              'طلبك رقم #${orderId.substring(0, 8).toUpperCase()} وصل إليك. شكراً ❤️',
        ),
      };

      final msg = messages[newStatus];
      if (msg != null) {
        // ✅ أرسل إشعار FCM
        if (token != null) {
          await NotificationService().sendToToken(
            token: token,
            title: msg.title,
            body: msg.body,
          );
        }

        // ✅ احفظ الإشعار في Firestore عشان يظهر في شاشة الإشعارات
        await NotificationService().saveNotificationToUser(
          userId: order.userId,
          title: msg.title,
          body: msg.body,
        );
      }

      // تحديث محلي
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