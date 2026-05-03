import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/controller/order_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final orders = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(title: Text("معلومات الطلب")),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: "Full Name "),
                validator: (v) => v!.isEmpty ? "required" : null,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: " Phone number"),
                validator: (v) => v!.isEmpty ? "required" : null,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: addressCtrl,
                decoration: InputDecoration(labelText: "address"),
                validator: (v) => v!.isEmpty ? "required" : null,
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: cityCtrl,
                decoration: InputDecoration(labelText: "City"),
                validator: (v) => v!.isEmpty ? "required" : null,
              ),

              SizedBox(height: 30),

              Obx(
                () => ElevatedButton(
                  onPressed: orders.isLoading.value
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          await orders.placeOrder(
                            cart,
                            name: nameCtrl.text,
                            phone: phoneCtrl.text,
                            address: addressCtrl.text,
                            city: cityCtrl.text,
                          );
                        },
                  child: orders.isLoading.value
                      ? CircularProgressIndicator()
                      : Text(" order confirmation"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
