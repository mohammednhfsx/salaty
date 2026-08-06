import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/models/product_model.dart';

class Admin extends StatelessWidget {
  final controller = Get.find<ProductController>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  final ProductModel? product;

  Admin({super.key, this.product}) {
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

  // 🎨 ألوان التصميم الجديد
  final Color primaryColor = const Color(0xFF009688); // Teal
  final Color bgColor = const Color(0xFFF8F9FA); 
  final Color cardColor = Colors.white;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: bgColor,
    appBar: AppBar(
      title: Text(
        isEdit ? "تعديل المنتج" : " ادارة المنتجات",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
    body: GetBuilder<ProductController>(
      builder: (c) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;

            final bool isMobile = screenWidth < 600;
            final bool isTablet =
                screenWidth >= 600 && screenWidth < 1000;
            final bool isDesktop = screenWidth >= 1000;

            final double horizontalPadding = isMobile
                ? 16
                : isTablet
                    ? 32
                    : 48;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  // يمنع تمدد المحتوى بشكل مبالغ على الويب
                  constraints: const BoxConstraints(
                    maxWidth: 1200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isEdit) ...[
                        _buildAdminHeader(),
                        const SizedBox(height: 24),
                      ],

                      // لابتوب وويب
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildDetailsCard(
                                c,
                                useTwoColumns: true,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 4,
                              child: _buildImagesCard(
                                c,
                                crossAxisCount: 3,
                              ),
                            ),
                          ],
                        )
                      // موبايل وتابلت
                      else
                        Column(
                          children: [
                            _buildDetailsCard(
                              c,
                              useTwoColumns: isTablet,
                            ),
                            const SizedBox(height: 24),
                            _buildImagesCard(
                              c,
                              crossAxisCount: screenWidth < 400 ? 2 : 3,
                            ),
                          ],
                        ),

                      const SizedBox(height: 32),

                      // زر الحفظ
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: isMobile ? double.infinity : 420,
                          child: _buildSaveButton(c),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
Widget _buildDetailsCard(
  ProductController c, {
  required bool useTwoColumns,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "التفاصيل الأساسية",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264653),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (useTwoColumns)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: nameController,
                  label: "اسم المنتج",
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: priceController,
                  label: "السعر",
                  icon: Icons.attach_money_rounded,
                  isNumber: true,
                ),
              ),
            ],
          )
        else ...[
          _buildTextField(
            controller: nameController,
            label: "اسم المنتج",
            icon: Icons.shopping_bag_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: priceController,
            label: "السعر",
            icon: Icons.attach_money_rounded,
            isNumber: true,
          ),
        ],

        const SizedBox(height: 16),

        _buildTextField(
          controller: descController,
          label: "الوصف",
          icon: Icons.description_outlined,
          maxLines: 3,
        ),

        const SizedBox(height: 16),

        _buildDropdown(c),
      ],
    ),
  );
}
Widget _buildImagesCard(
  ProductController c, {
  required int crossAxisCount,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.image_outlined,
              color: primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "صور المنتج",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264653),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "حتى 3 صور",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Text(
          "الصورة الأولى ستكون هي الرئيسية، انقر للإضافة",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final file = c.imageFiles[index];

            final String? oldUrl =
                isEdit && index < product!.images.length
                    ? product!.images[index]
                    : null;

            return _buildImagePicker(
              c,
              index,
              file,
              oldUrl,
            );
          },
        ),
      ],
    ),
  );
}

  // تصميم الهيدر لزر إدارة الطلبات
  Widget _buildAdminHeader() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.adminOrdersScreen),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF4A261), Color(0xFFE76F51)], // برتقالي متدرج أنيق
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: const Color(0xFFE76F51).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "إدارة الطلبات",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),textAlign: TextAlign.center,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // تصميم حقول الإدخال
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryColor, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  // تصميم القائمة المنسدلة للفئات
  Widget _buildDropdown(ProductController c) {
    return DropdownButtonFormField<String>(
      initialValue: c.selectedCategory,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      decoration: InputDecoration(
        labelText: "الفئة",
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(Icons.category_outlined, color: primaryColor, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      items: c.categoryList
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat, style: const TextStyle(fontWeight: FontWeight.w500)),
              ))
          .toList(),
      onChanged: (val) {
        if (val != null) c.setCategory(val);
      },
    );
  }

  // تصميم اختيار الصور
  Widget _buildImagePicker(ProductController c, int index, dynamic file, String? oldUrl) {
    final hasImage = file != null || oldUrl != null;

    return GestureDetector(
      onTap: () => c.pickImage(index),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasImage ? primaryColor : Colors.grey.shade300,
            width: hasImage ? 2 : 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: file != null
              ? Image.file(file, fit: BoxFit.cover)
              : oldUrl != null
                  ? Image.network(
                      oldUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _addIcon(index),
                    )
                  : _addIcon(index),
        ),
      ),
    );
  }

  Widget _addIcon(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey.shade400,
          size: 30,
        ),
        const SizedBox(height: 6),
        Text(
          "صورة ${index + 1}",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // تصميم زر الحفظ
  Widget _buildSaveButton(ProductController c) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: c.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  _showErrorSnackbar("الرجاء إدخال اسم المنتج");
                  return;
                }
                if (priceController.text.trim().isEmpty) {
                  _showErrorSnackbar("الرجاء إدخال سعر المنتج");
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
                    _showErrorSnackbar("الرجاء اختيار صورة واحدة على الأقل");
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
                backgroundColor: primaryColor,
                elevation: 6,
                // ignore: deprecated_member_use
                shadowColor: primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isEdit ? "حفظ التعديلات" : "إضافة المنتج",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  void _showErrorSnackbar(String msg) {
    Get.snackbar(
      "تنبيه",
      msg,
      // ignore: deprecated_member_use
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      borderRadius: 12,
    );
  }
}
