class ProductModel {
  String? id;
  String name;
  String description;
  double price;
  String image;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  //  تحويل من Firestore
  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }

  //  تحويل إلى Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "image": image,
    };
  }
}