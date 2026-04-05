import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

 dynamic validInput(String val ,String type ,int min ,int  max ){

  if(type == "username"){
    if(!GetUtils.isUsername(val)){
      return "not username";

    }
  }
    if(type == "email"){
    if(!GetUtils.isEmail(val)){
      return "not Emali";

    }
  }
      if(type == "phone"){
    if(!GetUtils.isPhoneNumber(val)){
      return "not phone";

    }
  }

  if(val.isEmpty){
    return " can`t be isEmpty ";
  }
  
  if(val.length < min){
    return " can`t  be less than $min";
  }
  if(val.length > max){
    return " can`t  be lange than $max";
  }





}


Future<void> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();

  bool isLogged = prefs.getBool("isLogged") ?? false;

  final user = FirebaseAuth.instance.currentUser;

  await user?.reload();

  if (user != null && user.emailVerified && isLogged) {
    Get.offAllNamed("/Homepage");
  } else {
    Get.offAllNamed("/login");
  }
}