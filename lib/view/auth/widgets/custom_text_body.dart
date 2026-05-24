import 'package:flutter/material.dart';

class CustomTextBody extends StatelessWidget {
  const CustomTextBody({super.key, required this.textbody});
  final String textbody;

  @override
  Widget build(BuildContext context) {
    return Text(
      textbody,
      style: TextStyle(color: Colors.grey[600], fontSize: 18),
    );
  }
}
