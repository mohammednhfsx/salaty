
import 'package:flutter/material.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/view/auth/fogotPassword/forget_password.dart';
import 'package:salaty/view/auth/fogotPassword/resetpassword.dart';
import 'package:salaty/view/auth/fogotPassword/success_resetpassword.dart';
import 'package:salaty/view/auth/fogotPassword/verifycode.dart';

import 'package:salaty/view/auth/screens/login_screen.dart';
import 'package:salaty/view/auth/screens/sign_up.dart';
import 'package:salaty/view/auth/screens/success_signup.dart';
import 'package:salaty/view/auth/screens/verify_code_signup.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // Auth
  AppRoutes.login: (context) =>  LoginScreen(),
  AppRoutes.signUp: (context) =>  SignUp(),
  AppRoutes.forgetPassword: (context) =>  ForgetPassword(),
  AppRoutes.verfiyCode: (context) =>  Verifycode(),
  AppRoutes.resetPassword: (context) =>  Resetpassword(),
  AppRoutes.VerifySignup: (context) =>  VerifySignup(),
  AppRoutes.successResetpassword: (context) =>  SuccessResetpassword(),
  AppRoutes.successSignUp: (context) =>  SuccessSignup(),


};