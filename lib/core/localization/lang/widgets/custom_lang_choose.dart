import 'package:flutter/material.dart';


class CustomLangChoose extends StatelessWidget {
    final String text;
    final void Function()?onPressed;
   final  bool isSelected;
   CustomLangChoose({super.key, required this.text, this.onPressed, required  this.isSelected});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color.fromARGB(255, 133, 252, 222) : Colors.grey[200],),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
