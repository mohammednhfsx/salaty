import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/models/product_model.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final ProductModel product = Get.arguments; //  ProductModel مو Map

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(title: Text(product.name),backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  صورة من الإنترنت بدل asset
            Image.network(
              product.image,
              width: double.infinity,
              height: 350,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 350,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  height: 350,
                  child: Center(
                    child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                );
              },
            ),

            SizedBox(height: 10),

            // اسم المنتج
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // السعر
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${product.price} د.ع",
                style: TextStyle(
                  fontSize: 22,
                  color:  Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            // الوصف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.description,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),

            SizedBox(height: 30),

            // زر إضافة للسلة
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    cartController.addToCart(product.toJson());
                    Get.snackbar(
                      "",
                      "",
                      backgroundColor: Colors.green,
                      titleText: const Text(
                        "Success",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      messageText: const Text(
                        "Added to cart",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color:   Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
