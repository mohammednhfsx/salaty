import 'package:flutter/material.dart';
import 'package:salaty/core/localization/lang/widgets/custom_lang_choose.dart';
import 'package:salaty/theme/colors.dart';


class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor:splash_screenColors ,
      body:Container(padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Text("Choose the application language",style: TextStyle(fontSize: 25,color: Colors.white),),
            SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
         

          
             
              CustomLangChoose(text: "EN",onPressed: () {
                
              },),
                  SizedBox(width: 25,),
              CustomLangChoose(text: "AR",onPressed: () {
                
              },)

                
            ],),
                         SizedBox(height: 25,),
                ElevatedButton(onPressed: (){}, child: Text("Next"),)
      
        
          
       ]),
      ));
  }
}