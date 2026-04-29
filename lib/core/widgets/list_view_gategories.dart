import 'package:flutter/material.dart';
import 'package:salaty/core/widgets/ListApp/list_categories.dart';

class ListViewGategories extends StatelessWidget {
  const ListViewGategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
       return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 5),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(radius: 28,
        backgroundColor:  const Color(0xFF28777C),

      
        
        child: Image.asset(
          categories[index]["image"]!,
        ),
      ),

      const SizedBox(height: 8),

      SizedBox(
        width: 70, 
        child: Text(
          categories[index]["name"]!,
          textAlign: TextAlign.center,
        
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
);
      },
    );
  }
}
