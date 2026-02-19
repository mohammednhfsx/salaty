import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/auth/screens/sign_up.dart';
import 'package:salaty/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(30),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Sign in to continue shopping",
                style: TextStyle(color: Colors.grey[600]),
              ),
        
              const SizedBox(height: 25),
              //  Email
              const Text(
                "Email or phone",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your email or phone",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Color(0xfff1f5f9),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //password
              const Text(
                "password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your password",
        
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_outlined),
                  filled: true,
                  fillColor: Color(0xfff1f5f9),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              //forget password
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forget password?",
                    style: TextStyle(color: splash_screenColors),
                  ),
                ),
              ),
              SizedBox( width: double.infinity,
                    height: 50,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: splash_screenColors,  shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),),
                  onPressed: () {}, child: Text('Sign in', style: TextStyle(color: Colors.white),),),
              ),
              const SizedBox(height: 100),

                /// Sign up
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {Get.to(SignUp());},
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ],
          ),
        ),
      ]),
    )));
  }
}
