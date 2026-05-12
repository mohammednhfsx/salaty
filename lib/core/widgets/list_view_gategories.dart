import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/home/product_controller.dart';

class ListViewGategories extends StatelessWidget {
  const ListViewGategories({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"name": "All",        "image": "assets/images/icons8-pc-30.png"},
      {"name": "Mobile",     "image": "assets/images/icons8-iphone-17-pro-50.png"},
      {"name": "Home",       "image": "assets/images/icons8-multiple-devices-24.png"},
      {"name": "Accessories","image": "assets/images/icons8-camera-32.png"},
      {"name": "Pc",         "image": "assets/images/icons8-pc-30.png"},
      {"name": "Laptop",     "image": "assets/images/icons8-laptop-30.png"},
    ];

    return GetBuilder<ProductController>(
      builder: (ctrl) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = ctrl.selectedCategory == cat['name'];

            return GestureDetector(
              onTap: () => ctrl.filterByCategory(cat['name']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0097A5) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.teal : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(cat['image']!, width: 22, height: 22,
                      color: isSelected ? Colors.white : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat['name']!.tr,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                            fontFamily: "Almarai-Regular"
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}