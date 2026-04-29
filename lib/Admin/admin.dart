import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/models/product_model.dart';

class AddProductPage extends StatelessWidget {
  final controller = Get.find<ProductController>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  final ProductModel? product;

  AddProductPage({super.key, this.product}) {
    if (product != null) {
      nameController.text = product!.name;
      priceController.text = product!.price.toString();
      descController.text = product!.description;
    }
    controller.imageFile = null;
  }

  bool get isEdit => product != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "تعديل المنتج" : "لوحة الأدمن"),
      ),
      body: GetBuilder<ProductController>(
        builder: (c) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ✅ زر إدارة الطلبات — في الأعلى بارز
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.adminOrdersScreen),
                    icon: const Icon(Icons.receipt_long, color: Colors.white),
                    label: const Text(
                      "إدارة الطلبات",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // ── فاصل ──
                const Divider(),
                const SizedBox(height: 8),

                // ── عنوان قسم المنتج ──
                Text(
                  isEdit ? "تعديل المنتج" : "إضافة منتج جديد",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المنتج",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "السعر",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "الوصف",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // ✅ عرض الصورة
                if (c.imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(c.imageFile!, height: 150, fit: BoxFit.cover),
                  )
                else if (isEdit && product!.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product!.image,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    ),
                  )
                else
                  const Icon(Icons.image, size: 80, color: Colors.grey),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () => c.pickImage(),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("اختر صورة"),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: c.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isEmpty) {
                              Get.snackbar("خطأ", "أدخل اسم المنتج");
                              return;
                            }
                            if (priceController.text.trim().isEmpty) {
                              Get.snackbar("خطأ", "أدخل السعر");
                              return;
                            }

                            if (isEdit) {
                              c.updateProduct(
                                id: product!.id ?? '',
                                name: nameController.text.trim(),
                                desc: descController.text.trim(),
                                price: double.tryParse(priceController.text) ?? 0,
                                oldImageUrl: product!.image,
                              );
                            } else {
                              if (c.imageFile == null) {
                                Get.snackbar("خطأ", "اختر صورة أولاً");
                                return;
                              }
                              c.addProduct(
                                name: nameController.text.trim(),
                                desc: descController.text.trim(),
                                price: double.tryParse(priceController.text) ?? 0,
                              );
                            }
                          },
                          child: Text(
                            isEdit ? "حفظ التعديلات" : "إضافة المنتج",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}