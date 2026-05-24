import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class Mymiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {

    final user = FirebaseAuth.instance.currentUser;

    // إذا ما مسجل دخول
    if (user == null) {
     
    }else{
   
    }
    return null;

 
}}