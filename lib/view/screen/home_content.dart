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
import 'package:salaty/view/screen/product_details.dart';
import 'package:salaty/view/screen/widgets/shimmer.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFfF3F7F8),
      floatingActionButton: GetBuilder<AuthController>(
        builder: (controller) {
          if (controller.isAdmin) {
            return FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              child: Icon(
                Icons.add,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Get.toNamed("/AddProductPage");
              },
            );
          }
          return SizedBox();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.teal,
          onRefresh: () async {
            await Get.find<ProductController>().getProducts();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),

            child: Column(
              children: [
                GetBuilder<AuthController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 60,
                            child: Image.asset("assets/images/logo12.png"),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                //============== search =====================
                SearchHome(),
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CustomText(
                        text: "Categories",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const SizedBox(height: 40, child: ListViewGategories()),

                const SizedBox(height: 15),
                const CustomContainerOff(),

                const Padding(
                  padding: EdgeInsets.only(left: 25, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "All Products",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                GetBuilder<ProductController>(
                  builder: (controller) {
                    if (controller.isShimmmer) {
                      return const ProductShimmer();
                    }
                    //  إذا ما يوجد منتجات
                    if (controller.products.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "No products yet",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.70,
                          ),
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        var product = controller.filteredProducts[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => ProductDetails(), arguments: product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                        child: Image.network(
                                          product.image,
                                          width: double.infinity,
                                          height: 150,
                                          fit: BoxFit.contain,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const SizedBox(
                                                  height: 150,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const SizedBox(
                                                  height: 150,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    // ✅ قائمة الأدمن
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GetBuilder<AuthController>(
                                        builder: (authController) {
                                          if (!authController.isAdmin) {
                                            return SizedBox();
                                          }
                                          return Container(
                                            height: 32,
                                            width: 32,
                                            decoration: BoxDecoration(
                                              // ignore: deprecated_member_use
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  Get.to(
                                                    () => AddProductPage(
                                                      product: product,
                                                    ),
                                                  );
                                                } else if (value == 'delete') {
                                                  Get.defaultDialog(
                                                    title: "حذف",
                                                    middleText:
                                                        "هل أنت متأكد من الحذف؟",
                                                    textConfirm: "نعم",
                                                    textCancel: "لا",
                                                    confirmTextColor:
                                                        Colors.white,
                                                    buttonColor: Colors.red,
                                                    onConfirm: () {
                                                      Get.find<
                                                            ProductController
                                                          >()
                                                          .deleteProduct(
                                                            product.id!,
                                                          );
                                                      Get.back();
                                                    },
                                                  );
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text("تعديل"),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text("حذف"),
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

                                const SizedBox(height: 8),

                                // ✅ اسم المنتج
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                //  الوصف كامل
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    product.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 15,),

                                //  السعر
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    "${product.price} د.ع",
                                    style: const TextStyle(
                                      color: Color(0xFF0097A5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
