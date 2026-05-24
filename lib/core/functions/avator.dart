import 'package:flutter/material.dart';

Widget buildUserAvatar(String name) {
  return CircleAvatar(
    radius: 35,
    backgroundColor: Colors.deepPurple,
    child: Text(
      name.isNotEmpty ? name[0].toUpperCase() : "?",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}