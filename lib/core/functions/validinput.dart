import 'package:get/get.dart';

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