import 'package:get/get.dart';
import 'package:salaty/models/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <CartModel>[].obs;

  // ================= ADD =================
  void addToCart(Map products) {
    int index = cartItems.indexWhere((item) => item.name == products['name']);
    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartModel(
          id: DateTime.now().toString(),
          name: products['name'],
          image: products['image'],
          price: double.parse(products['price'].replaceAll("\$", "")),
        ),
      );
    }
  }

  // ================= DELETE =================
  void removitem(int index) {
    cartItems.removeAt(index);
  }

  // ================= INCREASE =================
  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  // ================= DECREASE =================
  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  // ================= TOTAL =================
  double get total {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // ================= SHIPPING =================
  double get shoping {
    if (cartItems.isEmpty) return 0;
    if (total >= 50) {
      return 5;
    } else {
      return 0;
    }
  }

  // ================= Final total =================
  double get finaltotal {
    return total + shoping;
  }
}


//list.fold(initialValue, (result, element) => newResult)
//sum → المجموع الحالي
//item → المنتج الحالي
//Laptop → price = 1000 → quantity = 2
//Phone  → price = 500  → quantity = 1
//0 + (1000 × 2) = 2000
//2000 + (500 × 1) = 2500
//total = 2500

















  





