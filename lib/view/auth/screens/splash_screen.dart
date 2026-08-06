import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/core/constant/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // فحص المستخدم بعد ظهور شاشة البداية
    checkUser();
  }

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = authController.auth.currentUser;

    // لا يوجد مستخدم مسجل
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // تحديث بيانات Firebase Auth
    await user.reload();

    final refreshedUser = authController.auth.currentUser;

    // منع المستخدم غير المؤكد من الدخول
    if (refreshedUser == null || !refreshedUser.emailVerified) {
      await authController.auth.signOut();
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // جلب role من Firestore
    await authController.getUserData();

    // تحديد الصفحة حسب صلاحية المستخدم
    if (authController.isAdmin) {
      Get.offAllNamed(AppRoutes.Admin);
    } else {
      Get.offAllNamed(AppRoutes.homepage);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Image(
                  height: 120,
                  image: AssetImage("assets/images/logo12.png"),
                ),
              ),
            ),

            const SizedBox(height: 40),

            FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF009688),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}