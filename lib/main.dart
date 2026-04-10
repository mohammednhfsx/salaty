import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/cart/cart_controller.dart';


import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/route.dart';
import 'package:salaty/core/localization/lang/translation.dart';
import 'package:salaty/core/services/services.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await Firebase.initializeApp();

  Get.put(AuthController(), permanent: true);
  Get.put(CartController());
  


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    

   LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(translations: Mytranslation(),
    locale: controller.language,
     initialRoute: "/",   

  getPages: routes,
    
 
    );
  }
}
