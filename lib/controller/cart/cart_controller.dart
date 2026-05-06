import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salaty/models/cart_model.dart';

class CartController extends GetxController {

  var cartItems = <CartModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();

    if (uid != null) {
      loadCart();
    }
  }

  // ================= تحميل السلة من Firestore =================
  Future<void> loadCart() async {
    if (uid == null) return;
    try {
      isLoading.value = true;
      var doc = await firestore.collection('carts').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        var items = doc.data()!['items'] as List<dynamic>? ?? [];
        // ✅ نحوّل كل عنصر من Map إلى CartModel
        cartItems.value =
            items.map((e) => CartModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
     
      print("loadCart error: $e");  
    } finally {
      isLoading.value = false;
    }
  }

  // ================= حفظ السلة في Firestore =================
 
  Future<void> _saveCart() async {
    if (uid == null) return;
    try {
      await firestore.collection('carts').doc(uid).set({
        'items': cartItems.map((e) => e.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("saveCart error: $e");
    }
  }

  // ================= إضافة للسلة =================
  void addToCart(Map<String, dynamic> product) {
    
    int index = cartItems.indexWhere((item) => item.name == product['name']);

    if (index >= 0) {
  
      cartItems[index].quantity++;
      cartItems.refresh(); // 
    } else {
     
      cartItems.add(CartModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: product['name'],
        image: product['image'],
        price: (product['price'] as num).toDouble(),
      ));
    }

    _saveCart();
  }

  // ================= حذف عنصر =================
  void removitem(int index) {
    cartItems.removeAt(index);
    _saveCart(); 
  }

  // ================= زيادة الكمية =================
  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
    _saveCart();
  }

  // ================= تقليل الكمية =================
  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
      _saveCart();
    } else {
      
      removitem(index);
    }
  }

  // ================= تفريغ السلة =================
 
  Future<void> clearCart() async {
    cartItems.clear();
    await _saveCart();
  }

  // ================= الحسابات =================

  //  fold: يمشي على كل عنصر ويجمع
  // مثال: [laptop×2=2000, phone×1=500] → 2500
  double get total {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }



  double get finaltotal => total ;
}