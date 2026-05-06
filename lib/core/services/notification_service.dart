import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= تهيئة =================
  Future<void> initialize() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: android);
    await _local.initialize(settings: initSettings);

    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  // ================= الخطوة 1: قرأ Service Account =================
  Future<Map<String, dynamic>?> _readServiceAccount() async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/service_account.json');
      return jsonDecode(jsonStr);
    } catch (e) {
      print('❌ Service Account Error: $e');
      return null;
    }
  }

  // ================= الخطوة 2: ولّد JWT =================
  String? _generateJWT(Map<String, dynamic> serviceAccount) {
    try {
      final privateKey = serviceAccount['private_key'] as String;
      final clientEmail = serviceAccount['client_email'] as String;
      final now = DateTime.now();

      final jwt = JWT({
        'iss': clientEmail,
        'scope': 'https://www.googleapis.com/auth/firebase.messaging',
        'aud': 'https://oauth2.googleapis.com/token',
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'exp': (now.millisecondsSinceEpoch ~/ 1000) + 3600,
      });

      return jwt.sign(
        RSAPrivateKey(privateKey),
        algorithm: JWTAlgorithm.RS256,
      );
    } catch (e) {
      print('❌ JWT Error: $e');
      return null;
    }
  }

  // ================= الخطوة 3: جيب Access Token =================
  Future<String?> _getAccessToken() async {
    try {
      final serviceAccount = await _readServiceAccount();
      if (serviceAccount == null) return null;

      final jwtToken = _generateJWT(serviceAccount);
      if (jwtToken == null) return null;

      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwtToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('❌ OAuth2 Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Access Token Error: $e');
      return null;
    }
  }

  // ================= الخطوة 4: أرسل الإشعار =================
  Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final serviceAccount = await _readServiceAccount();
      if (serviceAccount == null) return;
      final projectId = serviceAccount['project_id'] as String;

      final accessToken = await _getAccessToken();
      if (accessToken == null) return;

      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'android': {'priority': 'high'},
          },
        }),
      );

      if (response.statusCode == 200) {
        print('✅ إشعار أُرسل بنجاح');
      } else {
        print('❌ FCM Error: ${response.body}');
      }
    } catch (e) {
      print('❌ sendToToken Error: $e');
    }
  }

  // ================= إرسال للأدمنز =================
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
        final fcmToken = doc.data()['fcmToken'];
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await sendToToken(token: fcmToken, title: title, body: body);
        }
      }
    } catch (e) {
      print('❌ notifyAdmins Error: $e');
    }
  }

  // ================= حفظ Token =================
  Future<void> saveToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final token = await _fcm.getToken();
      if (token == null) return;
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
      print('⚠️ FCM Token error: $e');
    }
  }

  // ================= إشعار محلي =================
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'salaty_channel',
          'Salaty Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
  // ✅ احفظ الإشعار في Firestore للزبون
Future<void> saveNotificationToUser({
  required String userId,
  required String title,
  required String body,
}) async {
  try {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add({
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('❌ saveNotification Error: $e');
  }
}
}
