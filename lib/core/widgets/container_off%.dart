import 'package:flutter/material.dart';
import 'package:salaty/core/widgets/custom_text.dart';

class ContainerOff extends StatelessWidget {
  const ContainerOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 147, 250),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Categories",
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            CustomText(
              text: "Get up to 50% off on selected items",
              fontSize: 15,
              color: const Color.fromARGB(255, 188, 233, 253),
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 30),
            Container(
              height: 44,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: AlignmentGeometry.center,
              child: CustomText(
                text: "Shop Now",
                fontSize: 19,
                color: Color.fromARGB(255, 21, 147, 250),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
