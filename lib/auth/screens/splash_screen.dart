import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salaty/auth/screens/login_screen.dart';
import 'package:salaty/theme/colors.dart';
class SplashScreen extends StatefulWidget {
const SplashScreen({super.key});

@override
State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen())) ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: splash_screenColors,
      body: Center(child: Text("Salaty",style: TextStyle(fontSize: 30,color: Colors.white),)),
    );
  }
}