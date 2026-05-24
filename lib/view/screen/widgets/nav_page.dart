import 'package:flutter/material.dart';
import 'package:salaty/view/screen/cart.dart';

import 'package:salaty/view/screen/order.dart';
import 'package:salaty/view/screen/profile/profile.dart';
import 'package:salaty/view/screen/home_content.dart';
import 'package:salaty/view/screen/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeContent(),
    const Cart(),
    const Orders(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}