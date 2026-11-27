
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/models/product_model.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final ProductModel product = Get.arguments;
    final currentIndex = 0.obs;
    final quantity = 1.obs;

    // ✅ منتجات مشابهة — نفس الكاتيجوري بدون المنتج الحالي
    final ProductController productCtrl = Get.find<ProductController>();
    final similarProducts = productCtrl.products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(6)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      // ✅ زر ثابت في الأسفل
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.08), blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            // ✅ كمية
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {
                      if (quantity.value > 1) quantity.value--;
                    },
                  ),
                  Obx(() => Text("${quantity.value}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () => quantity.value++,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // ✅ زر إضافة للسلة
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  for (int i = 0; i < quantity.value; i++) {
                    cartController.addToCart(product.toJson());
                  }
                  Get.snackbar(
                    "",
                    "",
                    backgroundColor: Colors.green,
                    titleText: const Text("Success ✅",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    messageText: const Text("Added to cart",
                        style:
                            TextStyle(fontSize: 14, color: Colors.white)),
                  );
                },
                child:  Text("Add_to_cart".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ══════════════════════════════
            // ✅ معرض الصور
            // ══════════════════════════════
            Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: SizedBox(
                    height: 320,
                    child: PageView.builder(
                      itemCount: product.images.length,
                      onPageChanged: (i) => currentIndex.value = i,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: CachedNetworkImage(imageUrl:  product.images[index] ,
                            fit: BoxFit.contain,
                            // while the image is loading
                            placeholder: (context, url) {
                               return const Center(
                                  child: CircularProgressIndicator(color:Colors.teal ,));
                              
                            },
                          //if the image Fails to load
                          errorWidget: (context, url, error) {
                       return Image(image: AssetImage("assets/images/22100c69-af75-4b19-977a-55c20bbefb4e.webp"));
                            
                          },
                         
                          ),
                        );
                      },
                    ),
                  ),
                ),



                // Dots
                if (product.images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              width:
                                  currentIndex.value == index ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentIndex.value == index
                                    ? Colors.teal
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        )),
                  ),

                // Counter
                if (product.images.length > 1)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${currentIndex.value + 1}/${product.images.length}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        )),
                  ),

             
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ══════════════════════════════
                  // اسم + سعر
                  // ══════════════════════════════
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "${product.price} د.ع",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // ══════════════════════════════
                  // ✅ الوصف مع bullet points
                  // ══════════════════════════════
                   Text("Description".tr,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ...product.description
                      .split('\n')
                      .where((line) => line.trim().isNotEmpty)
                      .map((line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text("• ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.teal)),
                                Expanded(
                                  child: Text(line.trim(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.6)),
                                ),
                              ],
                            ),
                          )),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // ══════════════════════════════
                  // ✅ قسم الضمان
                  // ══════════════════════════════
                   Text("Warranty".tr,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.teal.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          // ignore: deprecated_member_use
                          color: Colors.teal.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_outlined,
                            color: Colors.teal, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                           "text_warranty".tr,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ══════════════════════════════
            // ✅ منتجات مشابهة
            // ══════════════════════════════
            if (similarProducts.isNotEmpty) ...[
              const Divider(thickness: 8, color: Color(0xFFF3F7F8)),
               Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text("Similar_products".tr,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final p = similarProducts[index];
                    return GestureDetector(
                      onTap: () => Get.to(
                          () => const ProductDetails(),
                          arguments: p),
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(
                            right: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    // ignore: deprecated_member_use
                                    Colors.black.withOpacity(0.06),
                                blurRadius: 8)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                      top: Radius.circular(14)),
                              child: Image.network(
                                p.image,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    Container(
                                  height: 120,
                                  color: Colors.grey[100],
                                  child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(p.name,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text("${p.price} د.ع",
                                      style: const TextStyle(
                                          color: Colors.teal,
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}