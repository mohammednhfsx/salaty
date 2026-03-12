import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  List products = ["Apple", "Banana", "Orange"];

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: products
          .where((p) => p.toLowerCase().contains(query.toLowerCase()))
          .map((p) => ListTile(title: Text(p)))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = "", icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }
}