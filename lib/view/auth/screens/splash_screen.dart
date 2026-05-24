import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// أضفنا SingleTickerProviderStateMixin للتعامل مع الحركات (Animations)
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. إعداد المتحكم بالحركة بمدة ثانية ونصف
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. إعداد حركة التكبير (تبدأ من النصف وتصل للحجم الطبيعي مع حركة ارتدادية)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack, 
      ),
    );

    // 3. إعداد حركة الظهور التدريجي (من الشفافية التامة للوضوح)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // 4. تشغيل الحركة فور فتح الشاشة
    _animationController.forward();

    // 5. المؤقت الخاص بالانتقال (3 ثواني)
    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.offNamed("/login");
      } else {
        Get.offNamed("/homepage");
      }
    });
  }

  @override
  void dispose() {
    // تنظيف المتحكم بالحركة عند الخروج من الشاشة لتجنب استهلاك الذاكرة
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
            // تطبيق حركتي التلاشي والتكبير على الشعار
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Image(
                  height: 120, // كبرنا الشعار قليلاً ليكون أوضح
                  image: AssetImage("assets/images/logo12.png"),
                ),
              ),
            ),
            const SizedBox(height: 40), // مسافة بين الشعار ومؤشر التحميل
            
            // مؤشر تحميل يظهر مع نفس الحركة ليعطي إيحاء بالتفاعل
            FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF009688), // لون مقارب للون الأيقونة المرفقة بالصورة (Teal)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
