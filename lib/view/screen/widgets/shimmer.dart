import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: 0.52,
      ),
      itemCount: 4, // 4 كاردات وهمية
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 247, 244, 244)!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مكان الصورة
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                ),
                SizedBox(height: 8),
                // مكان الاسم
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 14,
                    width: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                // مكان الوصف
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 10,
                    width: 140,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 10,
                    width: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                // مكان السعر
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 14,
                    width: 70,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
