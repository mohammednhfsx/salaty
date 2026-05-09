import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(backgroundColor:  const Color.fromARGB(255, 253, 253, 253),
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:  const Color(0xFF0097A5),
      unselectedItemColor: Colors.grey,
      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: "Cart",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: "Orders",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),

      ],
    );
  }
}