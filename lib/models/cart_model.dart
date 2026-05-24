class CartModel {
  String id;
  String name;
  String image;
  double price;
  int quantity;

  CartModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'] * 1.0,
      quantity: json['quantity'],
    );
  }
}