import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomLangChoose extends StatelessWidget {
    final String text;
    final void Function()?onPressed;
     bool isSelected = false;
    CustomLangChoose({super.key, required this.text, this.onPressed, required  this.isSelected});


  @override
  Widget build(BuildContext context) {
    return SizedBox(width:300 ,height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color.fromARGB(255, 75, 180, 241) : Colors.grey[100],),
        onPressed: onPressed,
        child: Text(text),
        
      ),
    );
  }
}
