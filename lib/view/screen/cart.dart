import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/core/theme/colors.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Shopping Cart"),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Items ${cartController.cartItems.length}"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /// ================= LIST =================
          Expanded(
            child: Obx(
              () => cartController.cartItems.isEmpty
                  ? Center(
                      child: Text(
                        "Your cart is empty 🛒",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 207, 206, 206),
                        ),
                      ),
                    )
                  : ListView.builder(
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
                                BoxShadow(color: Colors.grey, blurRadius: 1.5),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            // ================= image =================
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(item.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),
                                //====================== price =========================
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\$${item.price}",
                                        style: TextStyle(
                                          color: splash_screenColors,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      //=================== INCREASE and DECREASE =================
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(
                                              0xFFE9F2FF,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                cartController.decreaseQty(
                                                  index,
                                                );
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                          ),

                                          Text(item.quantity.toString()),
                                          CircleAvatar(
                                            backgroundColor: const Color(
                                              0xFFE9F2FF,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                cartController.increaseQty(
                                                  index,
                                                );
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              cartController.removitem(index);
                                            },
                                            icon: Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.red,
                                            ),
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
                    ),
            ),
          ),

          /// ================= SUMMARY =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                // ================= Subtotal =================
                Obx(
                  () => cartController.cartItems.isEmpty
                      ? SizedBox()
                      : _buildRow(
                          "Subtotal",
                          "\$${cartController.total.toStringAsFixed(2)}",
                        ),
                ),
                // ================= Shipping =================
                Obx(
                  () => cartController.cartItems.isEmpty
                      ? SizedBox()
                      : _buildRow(
                          "Shipping",
                          "\$${cartController.shoping.toStringAsFixed(2)}",
                        ),
                ),
                const Divider(),

                // ================= finaltotal =================
                Obx(
                  () => cartController.cartItems.isEmpty
                      ? SizedBox()
                      : _buildRow(
                          "Total",
                          "\$${cartController.finaltotal.toStringAsFixed(2)}",
                          isTotal: true,
                        ),
                ),

                const SizedBox(height: 15),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? Colors.blue : Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
