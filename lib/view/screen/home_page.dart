import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/core/widgets/ListApp/list_categories.dart';
import 'package:salaty/core/widgets/custom_container_off.dart';
import 'package:salaty/core/widgets/custom_text.dart';
import 'package:salaty/core/widgets/list_view_gategories.dart';
import 'package:salaty/core/widgets/search_home.dart';
import 'package:salaty/view/screen/bottom_nav_bar.dart';
import 'package:salaty/view/screen/product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "ShopHub",
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Discover amazing products",
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart_checkout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                //=================================================
                //search
                //==============================================
                SearchHome(),
                SizedBox(height: 10),
                Divider(),

                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Categories",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: CustomText(
                      //     text: "See All  ",
                      //     fontSize: 16,
                      //     color: splash_screenColors,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                //===============================================================================
                // ListView Gategories
                //===============================================================================
                SizedBox(height: 15),
                SizedBox(height: 100, child: ListViewGategories()),
                const SizedBox(height: 40),

                //=========================================================================
                // container  off%
                //===============================================================================
                CustomContainerOff(),

                //=========================================================================
                // GridView products
                //===============================================================================
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "All Products",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: CustomText(
                      //     text: "See All  ",
                      //     fontSize: 16,
                      //     color: splash_screenColors,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ProductDetails());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEEF2F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// image products
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    products[index]['image']!,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// off%
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "-${products[index]['price']!}%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            /// name products
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                products[index]['name']!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            SizedBox(height: 6),

                            /// price
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text(
                                    products[index]['price']!,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    products[index]['price']!,
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 6),

                            /// التقييم
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 8),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.star, color: Colors.orange, size: 16),
                            //       SizedBox(width: 4),
                            //       Text(product.rating.toString()),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          currentIndex = index;
        },
      ),
    );
  }
}
