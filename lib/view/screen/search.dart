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

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Container(decoration: BoxDecoration(  color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              border:BoxBorder.all(color: Colors.grey,width: 1,) ),
              
            child: ListTile(
              // ✅ صورة المنتج في القائمة
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  width: 70,
                  height: 70,
            
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${product.price} د.ع",
                style: const TextStyle(color: Colors.blue),
              ),
              // ✅ عند الضغط → نفتح صفحة تفاصيل المنتج
              onTap: () {
                close(context, null); // نغلق البحث أولاً
                Get.to(() => const ProductDetails(), arguments: product);
              },
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