import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormfield extends StatelessWidget {
  final void Function()? onTapicon;
  final String hintText;
  final TextEditingController controllertextfield;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)valid;
  final bool? obscureText;
   const CustomTextFormfield({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.controllertextfield, required this.valid,
    this.onTapicon, this.obscureText
  
   
  });
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(validator:valid ,
    obscureText:obscureText == null  || obscureText == false?  false :true ,
      
      controller: controllertextfield,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: InkWell(onTap:onTapicon ,child: Icon(suffixIcon, color: Colors.grey),),
        prefixIcon: Icon(prefixIcon),

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
    );
  }
}
