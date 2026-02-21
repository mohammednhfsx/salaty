import 'package:flutter/material.dart';


class CustomLangChoose extends StatelessWidget {
    final String text;
    final void Function()?onPressed;
  const CustomLangChoose({super.key, required this.text, this.onPressed});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
