
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/controller/notification_controller.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/core/services/notification_service.dart';
import 'package:salaty/route.dart';
import 'package:salaty/core/localization/lang/translation.dart';
import 'package:salaty/core/services/services.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1: Firebase أولاً
  await Firebase.initializeApp();

  // 2: Background Handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 3: Services
  await initialServices();

  // 4: الإشعارات
await NotificationService().initialize();

  // 5: Controllers
  Get.put(AuthController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(ProductController(), permanent: true);
  Get.put(OrderController(), permanent: true);
  Get.put(NotificationController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Mytranslation(),
      locale: controller.language,
      initialRoute: "/",
      getPages: routes,
    );
  }
}