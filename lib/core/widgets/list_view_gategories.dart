
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:salaty/controller/home/product_controller.dart';

class ListViewGategories extends StatelessWidget {
  const ListViewGategories({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"name": "All", "image": "assets/images/icons8-pc-30.png"},
      {"name": "Mobile", "image": "assets/images/icons8-iphone-17-pro-50.png"},
      {"name": "Home", "image": "assets/images/icons8-multiple-devices-24.png"},
      {"name": "Accessories", "image": "assets/images/icons8-camera-32.png"},
      {"name": "Pc", "image": "assets/images/icons8-pc-30.png"},
      {"name": "Laptop", "image": "assets/images/icons8-laptop-30.png"},
    ];

    return GetBuilder<ProductController>(
      builder: (ctrl) {
        // إذا كان التحميل جارياً
        if (ctrl.isShimmmer) {
          return _categoryShimmer();
        }

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
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0097A5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0097A5)
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      cat['image']!,
                      width: 22,
                      height: 22,
                      color: isSelected ? Colors.white : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cat['name']!.tr,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontFamily: "Almarai-Regular",
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

  // Category Shimmer
  Widget _categoryShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8EAF0),
      highlightColor: const Color(0xFFF8FAFC),
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: index == 0 ? 85 : 110,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
