import 'package:flutter/material.dart';

class CustomTextLable extends StatelessWidget {
  const CustomTextLable({super.key, required this.textLable});


  final String textLable;

  @override
  Widget build(BuildContext context) {
    return Text(textLable, style: TextStyle(fontWeight: FontWeight.bold));
  }
}
