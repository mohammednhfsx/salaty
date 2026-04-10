import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final product = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                product['image'],
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),

              /// off%
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "-${product['price']!}%",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          //============================
          // name product
          //=============================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              product['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          //=================================
          /// price
          //==================================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  product['price']!,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  product['price']!,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          //===================================
          //rating
          //====================================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text(
                  product['rating'].toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          //======================================
          //Description
          //======================================
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Text(
              product['description'],
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                cartController.addToCart(product);

               Get.snackbar(
  "",
  "",
  backgroundColor: Colors.green,
  titleText: const Text(
    "Success",
    style: TextStyle(
      fontSize: 20, // 🔥 حجم العنوان
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  messageText: const Text(
    "Added to cart",
    style: TextStyle(
      fontSize: 16, // 🔥 حجم النص
      color: Colors.white,
    ),
  ),
);
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                alignment: AlignmentGeometry.center,
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
