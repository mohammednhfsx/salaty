import 'package:flutter/material.dart';
import 'package:salaty/view/screen/search.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({super.key});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
  onTap: () {
    showSearch(
      context: context,
      delegate: Search(),
    );
  },
  child: Padding(
    padding: const EdgeInsets.only(right: 20,left: 20),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xffEEF2F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: 10),
          Text("Search products..."),
        ],
      ),
    ),
  ),
);

  }
}