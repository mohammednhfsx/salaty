import 'package:flutter/material.dart';
import 'package:salaty/core/widgets/ListApp/list_categories.dart';

class ListViewGategories extends StatelessWidget {
  const ListViewGategories({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Color(0xffEEF2F7),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(categories[index]["image"]!),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]["name"]!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
  }
}