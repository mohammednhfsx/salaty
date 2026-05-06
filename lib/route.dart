import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:salaty/Admin/admin.dart';
import 'package:salaty/Admin/admin_order.dart';
import 'package:salaty/core/constant/route.dart';

import 'package:salaty/view/auth/fogotPassword/resetpassword.dart';
import 'package:salaty/view/auth/fogotPassword/success_resetpassword.dart';
import 'package:salaty/view/auth/fogotPassword/verifycode.dart';
import 'package:salaty/view/auth/screens/login_screen.dart';
import 'package:salaty/view/auth/screens/sign_up.dart';
import 'package:salaty/view/auth/screens/splash_screen.dart';
import 'package:salaty/view/auth/screens/success_signup.dart';
import 'package:salaty/view/auth/screens/verify_code_login.dart';
import 'package:salaty/view/auth/screens/verify_code_signup.dart';
import 'package:salaty/view/screen/cart.dart';
import 'package:salaty/view/screen/checkout_screen.dart';
import 'package:salaty/view/screen/notifications_screen.dart';
import 'package:salaty/view/screen/widgets/nav_page.dart';

import 'package:salaty/view/screen/order.dart';
import 'package:salaty/view/screen/profile/profile.dart';

List<GetPage<dynamic>>? routes = [
    // GetPage(name: "/", page: () => LoginScreen(), ),
  GetPage(name: "/", page: () => SplashScreen(), ),
  GetPage(name: AppRoutes.login, page: () => LoginScreen()),
  GetPage(name: AppRoutes.signUp, page: () => SignUp()),
  GetPage(name: AppRoutes.forgetPassword, page: () => ForgotPasswordScreen()),
  GetPage(name: AppRoutes.verfiyCode, page: () => Verifycode()),
  GetPage(name: AppRoutes.resetPassword, page: () => ForgotPasswordScreen()),
  GetPage(name: AppRoutes.verifySignup, page: () => VerifySignup()),
  GetPage(
    name: AppRoutes.successResetpassword,
    page: () => SuccessResetpassword(),
  ),
  GetPage(name: AppRoutes.successSignUp, page: () => SuccessSignup()),
  GetPage(name: AppRoutes.homepage, page: () => HomePage()),
  GetPage(name: AppRoutes.verifyCodeLogin, page: () => VerifyLoginScreen()),
  GetPage(name: AppRoutes.cart, page: () => Cart()),
  GetPage(name: AppRoutes.orders, page: () => Orders()),
  GetPage(name: AppRoutes.profile, page: () => Profile()),
    GetPage(name: AppRoutes.addProductPage, page: () => AddProductPage()),
        GetPage(name: AppRoutes.adminOrdersScreen, page: () => AdminOrdersScreen()),
         GetPage(name: AppRoutes.checkoutScreen, page: () => CheckoutScreen()),
                 GetPage(name: AppRoutes.notifications, page: () => NotificationsScreen()),
         
        
  
  
  
  ];
