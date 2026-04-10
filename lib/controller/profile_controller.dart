import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController  extends GetxController{
  var userData = {}.obs;
   //connect db
  FirebaseFirestore firestore =FirebaseFirestore.instance;
   String userid = FirebaseAuth.instance.currentUser!.uid;
   @override
  void onInit() {
    
    super.onInit();
    getUserData();
  }
  getUserData()async{
    var doc =await firestore.collection('users').doc(userid).get();
    userData.value = doc.data()
    !;
  }



}