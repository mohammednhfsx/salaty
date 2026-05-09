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

      final validCategories = [
        'Mobile', 'Home', 'Accessories', 'Pc', 'Laptop', 'Other',
      ];
      controller.selectedCategory = validCategories.contains(product!.category)
          ? product!.category
          : 'Other';
    } else {
      controller.selectedCategory = 'Mobile';
    }
    // ✅ reset الصور عند الفتح
    controller.imageFiles = [null, null, null];
  }

  bool get isEdit => product != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "تعديل المنتج" : "لوحة الأدمن")),
      body: GetBuilder<ProductController>(
        builder: (c) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── زر إدارة الطلبات ──
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.adminOrdersScreen),
                    icon: const Icon(Icons.receipt_long, color: Colors.white),
                    label: const Text("إدارة الطلبات",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const Divider(),
                const SizedBox(height: 8),

                Text(
                  isEdit ? "تعديل المنتج" : "إضافة منتج جديد",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "اسم المنتج",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "السعر", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: "الوصف", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: controller.selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "الفئة",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: controller.categoryList
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.setCategory(val);
                  },
                ),

                const SizedBox(height: 20),

                // ══════════════════════════════
                // ✅ 3 Slots للصور
                // ══════════════════════════════
                const Text("صور المنتج (حتى 3 صور)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text("الصورة الأولى هي الرئيسية",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),

                Row(
                  children: List.generate(3, (index) {
                    final file = c.imageFiles[index];
                    // صورة موجودة من الـ Edit
                    final oldUrl = isEdit && index < product!.images.length
                        ? product!.images[index]
                        : null;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => c.pickImage(index),
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: file != null
                                  ? Colors.teal
                                  : Colors.grey.shade300,
                              width: file != null ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: file != null
                                ? Image.file(file, fit: BoxFit.cover)
                                : oldUrl != null
                                    ? Image.network(oldUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _addIcon(index))
                                    : _addIcon(index),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // ── زر الحفظ ──
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
                                oldImages: product!.images,
                                category: c.selectedCategory,
                              );
                            } else {
                              if (c.imageFiles.every((f) => f == null)) {
                                Get.snackbar("خطأ", "اختر صورة واحدة على الأقل");
                                return;
                              }
                              c.addProduct(
                                name: nameController.text.trim(),
                                desc: descController.text.trim(),
                                price: double.tryParse(priceController.text) ?? 0,
                                category: c.selectedCategory,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isEdit ? "حفظ التعديلات" : "إضافة المنتج",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
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

  Widget _addIcon(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            color: Colors.grey[400], size: 28),
        const SizedBox(height: 4),
        Text("صورة ${index + 1}",
            style: TextStyle(fontSize: 11, color: Colors.grey[400])),
      ],
    );
  }
}