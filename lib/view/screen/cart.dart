import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:salaty/controller/cart/cart_controller.dart';

import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/core/constant/route.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text("Shopping_Cart".tr),
        actions: [
          // ✅ عدد العناصر في الـ AppBar
          Obx(() => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Items ${cartController.cartItems.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          // ================= قائمة المنتجات =================
          Expanded(
            child: Obx(() {
              // ✅ Obx: يراقب cartItems.obs
              if (cartController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   SizedBox(height: 300,
                    child: Lottie.asset("assets/lottile/empty.json")),
                      const SizedBox(height: 16),
                       Text(
                    "There's_nothing_in_the_basket".tr,

                        style: TextStyle(
                            fontSize: 24,
                            fontFamily:'Almarai-Regular' ,
                            color: Color.fromARGB(255, 12, 9, 9)),
                      ),
                       Text(
                 "Browse_the_store_and_add_your_products".tr,
                    textAlign: TextAlign.center,

                        style: TextStyle(
                            fontSize: 15,
                            fontFamily:'Almarai-Regular' ,
                            color: Color.fromARGB(255, 109, 109, 109)),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        boxShadow: [
                          // ignore: deprecated_member_use
                          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // الصورة
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Text(
                                  "${item.price} د.ع",
                                  style: TextStyle(
                                      color:  const Color(0xFF0097A5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                // أزرار الكمية
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      // ignore: deprecated_member_use
                                      backgroundColor: const Color(0xFF0097A5).withOpacity(0.4),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () =>
                                            cartController.decreaseQty(index),
                                        icon: const Icon(Icons.remove, size: 16),
                                      ),
                                    ),
                                    Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    CircleAvatar(
                                      radius: 16,
                                      // ignore: deprecated_member_use
                                      backgroundColor:  const Color(0xFF0097A5).withOpacity(0.4),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () =>
                                            cartController.increaseQty(index),
                                        icon: const Icon(Icons.add, size: 16),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          cartController.removitem(index),
                                      icon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // ================= ملخص الطلب =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Obx(() {
              if (cartController.cartItems.isEmpty) return const SizedBox();
              return Column(
                children: [
                  _buildRow("Subtotal".tr,
                      "${cartController.total.toStringAsFixed(2)} د.ع"),
                  // _buildRow("Shipping",
                  //     "${cartController.shoping.toStringAsFixed(2)} د.ع"),
                  const Divider(),
                  _buildRow(
                      "Total".tr,
                      "${cartController.finaltotal.toStringAsFixed(2)} د.ع",
                      isTotal: true),
                  const SizedBox(height: 15),

                  // ✅ زر Checkout مربوط بـ OrderController
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() => ElevatedButton(
                          // ✅ لو isLoading = true، نعطّل الزر منعاً لضغطات متعددة
                          onPressed: orderController.isLoading.value
                              ? null
                              : () { Get.toNamed(AppRoutes.checkoutScreen);},
                              //  orderController.placeOrder(cartController),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0097A5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: orderController.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              :  Text(
                                "Proceed_to_Checkout".tr,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        )),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                color: isTotal ?  const Color(0xFF0097A5) : Colors.black,
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}