import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:salaty/controller/home/product_controller.dart';
import 'package:salaty/models/product_model.dart';
import 'package:salaty/view/screen/product_details.dart';



class Search extends SearchDelegate {
  
  final ProductController productCtrl = Get.find<ProductController>();

  //  بناء نتائج البحث
  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  // ✅ اقتراحات أثناء الكتابة (نفس buildResults)
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    

    final List<ProductModel> results = productCtrl.products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (query.isEmpty) {
      return  Center(
        child:   SizedBox(height: 160,
          child: Lottie.asset('assets/lottile/Search.json')),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               SizedBox(height: 160,
          child: Lottie.asset('assets/lottile/error.json')),
          Text("No results found",style: TextStyle(fontSize: 18,color: Colors.grey),),
       
            const SizedBox(height: 10),
    
          ],
        ),
      );
    }

  return GridView.builder(
  padding: const EdgeInsets.all(10),
  itemCount: results.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // عمودين
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.9, // يتحكم بالطول
  ),
  itemBuilder: (context, index) {
    final product = results[index];

    return GestureDetector(
      onTap: () {
        close(context, null);
        Get.to(() => const ProductDetails(), arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ الصورة
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ✅ الاسم
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

           

            const SizedBox(height: 6),

            // ✅ السعر
            Text(
              "${product.price} د.ع",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }

  // ✅ أزرار على يمين شريط البحث
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  // ✅ زر الرجوع على يسار شريط البحث
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }
}