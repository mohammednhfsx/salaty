import 'package:flutter/material.dart';

class CustomTextTitle extends StatelessWidget {
  const CustomTextTitle({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }
}
