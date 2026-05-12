import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/Admin/admin.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/core/constant/route.dart';

import 'package:salaty/core/widgets/custom_container_off.dart';
import 'package:salaty/core/widgets/custom_text.dart';
import 'package:salaty/core/widgets/list_view_gategories.dart';
import 'package:salaty/core/widgets/search_home.dart';
import 'package:salaty/models/product_model.dart';
import 'package:salaty/view/screen/product_details.dart';
import 'package:salaty/view/screen/widgets/shimmer.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), 
      floatingActionButton: GetBuilder<AuthController>(
        builder: (controller) {
          if (controller.isAdmin) {
            return FloatingActionButton(
              elevation: 4,
              backgroundColor: const Color(0xFF009688), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Get.toNamed("/AddProductPage");
              },
            );
          }
          return const SizedBox();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF009688),
          onRefresh: () async {
            await Get.find<ProductController>().getProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // ── Header (Logo & Notifications) ──
                GetBuilder<AuthController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // اللوجو
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              "assets/images/logo12.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          // أيقونة الإشعارات المطورة
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Color(0xFF009688),
                                    size: 24,
                                  ),
                                  // النقطة الحمراء للإشعارات
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      height: 8,
                                      width: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ── شريط البحث ──
                const SearchHome(),
                
                const SizedBox(height: 24),

                // ── قسم الفئات (Categories) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       CustomText(
                        text: "Categories".tr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                     
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const SizedBox(
                  height: 45, 
                  child: ListViewGategories(),
                ),

                const SizedBox(height: 24),

                // ── البانر الإعلاني ──
                const CustomContainerOff(),

                const SizedBox(height: 30),

                // ── عنوان المنتجات ──
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: "All_Products".tr,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // ── شبكة المنتجات (Grid View) ──
                GetBuilder<ProductController>(
                  builder: (controller) {
                    if (controller.isShimmmer) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ProductShimmer(),
                      );
                    }

                    if (controller.products.isEmpty) {
                      return  Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                             "No_products_yet".tr,
                                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65, // تم ضبط النسبة لتلائم الصور والنصوص بشكل مريح
                      ),
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        var product = controller.filteredProducts[index];
                        return _buildProductCard(product);
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── تصميم بطاقة المنتج (Product Card) ──
  Widget _buildProductCard(ProductModel  product) {
    return InkWell(
      onTap: () {
        Get.to(() => ProductDetails(), arguments: product);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── قسم الصورة ──
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,// لون خلفية هادئ للصور لإبرازها
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF009688)),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // ── قائمة الإدارة (Admin) ──
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GetBuilder<AuthController>(
                      builder: (authController) {
                        if (!authController.isAdmin) return const SizedBox();
                        return Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black87,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.to(() => AddProductPage(product: product));
                              } else if (value == 'delete') {
                                _showDeleteDialog(product.id!);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                    SizedBox(width: 10),
                                    Text("تعديل", style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: const [
                                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    SizedBox(width: 10),
                                    Text("حذف", style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── قسم التفاصيل والنصوص ──
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "${product.price} د.ع",
                            style: const TextStyle(
                              color: Color(0xFF009688),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // إضافة أيقونة تسوق صغيرة (تعطي طابع جمالي للمتاجر)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF009688).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Color(0xFF009688),
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── مربع حوار تأكيد الحذف ──
  void _showDeleteDialog(String productId) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: "هل أنت متأكد من أنك تريد حذف هذا المنتج؟",
      middleTextStyle: const TextStyle(fontSize: 14),
      textConfirm: "حذف",
      textCancel: "تراجع",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black87,
      buttonColor: Colors.redAccent,
      radius: 16,
      contentPadding: const EdgeInsets.all(20),
      onConfirm: () {
        Get.find<ProductController>().deleteProduct(productId);
        Get.back();
      },
    );
  }
}
