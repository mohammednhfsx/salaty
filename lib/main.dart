import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/route.dart';
import 'package:salaty/view/auth/screens/splash_screen.dart';
import 'package:salaty/core/localization/lang/translation.dart';
import 'package:salaty/core/services/services.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

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
  home: SplashScreen(),
  routes: routes,
    
 
    );
  }
}
