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
    padding: EdgeInsets.only(right: 20, left: 20),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 45,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey),
        color: Colors.white30,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search,color:  Colors.grey,),
          SizedBox(width: 10),
          Text("Search products...",style: TextStyle(color: Colors.grey),),
        ],
      ),
    ),
  ),
);

  }
}

