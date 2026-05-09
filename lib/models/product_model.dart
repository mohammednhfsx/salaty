class ProductModel {
  String? id;
  String name;
  String description;
  double price;
  List<String> images;
   String category;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images, this.category = 'Other',
  });
   String get image => images.isNotEmpty ? images.first : '';

  //  تحويل من Firestore
  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [json['image'] ?? ''],
            category: json['category'] ?? 'Other',
    );
  }

  //  تحويل إلى Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      'images': images, 
      'image': images.isNotEmpty ? images.first : '', //  للتوافق مع القد
       'category': category,
    };
  }
}