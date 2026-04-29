import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/route.dart';
import 'package:salaty/core/localization/lang/translation.dart';
import 'package:salaty/core/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  await initialServices();


  Get.put(AuthController(), permanent: true);
  Get.put(CartController(),  permanent: true);
  Get.put(ProductController(), permanent: true);
   Get.put(OrderController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    
        //  نفحص إذا المستخدم مسجّل دخول
        // currentUser يرجع null إذا ما في أحد مسجّل

    User? user = FirebaseAuth.instance.currentUser;

    return GetMaterialApp(  debugShowCheckedModeBanner: false,
      translations: Mytranslation(),
      locale: controller.language,
      initialRoute: user == null ? "/login" : "/homepage",

      getPages: routes,
    );
  }
}
