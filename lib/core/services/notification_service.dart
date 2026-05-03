import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

// ✅ Background handler — لازم يكون top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // الإشعار يظهر تلقائياً من النظام عند التطبيق مغلق
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ FCM Server Key — من Firebase Console → Project Settings → Cloud Messaging
  static const String _serverKey = '751020501218';

  // ================= تهيئة =================
  Future<void> initialize() async {
  await _fcm.requestPermission(alert: true, badge: true, sound: true);

  const AndroidInitializationSettings android =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  // ✅ initializationSettings بدل InitializationSettings مباشرة
  const InitializationSettings initializationSettings =
      InitializationSettings(android: android);
      
  await _local.initialize(settings: initializationSettings);

  FirebaseMessaging.onMessage.listen((message) {
    _showLocalNotification(message);
  });
}


  // ================= حفظ Token =================
Future<void> saveToken() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  try {
    final token = await _fcm.getToken();
    if (token == null) return; // ✅ لو ما جاب token ما يكسر

    await _firestore.collection('users').doc(uid).set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );

    _fcm.onTokenRefresh.listen((newToken) async {
      await _firestore.collection('users').doc(uid).set(
        {'fcmToken': newToken},
        SetOptions(merge: true),
      );
    });
  } catch (e) {
    // ✅ ما يطلع snackbar — بس يسجل الخطأ
    print('⚠️ FCM Token error: $e');
  }
}
  // ================= إرسال إشعار لـ Token معين =================
  Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {'title': title, 'body': body},
          'android': {'priority': 'high'},
        }),
      );
    } catch (e) {
      print('❌ FCM Error: $e');
    }
  }

  // ================= إرسال إشعار لكل الأدمنز =================
  Future<void> notifyAdmins({
    required String title,
    required String body,
  }) async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      for (var doc in snap.docs) {
        final token = doc.data()['fcmToken'];
        if (token != null && token.isNotEmpty) {
          await sendToToken(token: token, title: title, body: body);
        }
      }
    } catch (e) {
      print('❌ notifyAdmins Error: $e');
    }
  }

  // ================= إشعار محلي (تطبيق مفتوح) =================
Future<void> _showLocalNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'salaty_channel',
    'Salaty Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  // ✅ id كـ named parameter
  await _local.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: notification.title,
    body: notification.body,
    notificationDetails: const NotificationDetails(android: androidDetails),
  );
}
}