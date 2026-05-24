import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  var notifications = <Map<String, dynamic>>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (uid != null) listenToNotifications();
  }

  // ✅ Stream — يتحدث تلقائياً عند وصول إشعار جديد
  void listenToNotifications() {
    _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      notifications.value = snap.docs
          .map((d) => {'id': d.id, ...d.data()})
          .toList();
      unreadCount.value =
          notifications.where((n) => n['isRead'] == false).length;
    });
  }

  // ✅ تعليم كل الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    if (uid == null) return;
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    for (var doc in snap.docs) {
      await doc.reference.update({'isRead': true});
    }
    unreadCount.value = 0;
  }

  // ✅ حذف إشعار
  Future<void> deleteNotification(String notifId) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notifId)
        .delete();
  }
}