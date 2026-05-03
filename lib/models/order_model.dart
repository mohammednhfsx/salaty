import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salaty/models/cart_model.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<CartModel> items;
  final double total;
  final String status;
  final DateTime? createdAt;
  final String customerName;
  final String phone;
  final String address;
  final String city;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
    this.status = 'pending',
    this.createdAt,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.city,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      customerName: json['customerName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',

      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'city': city,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  OrderModel copyWith({String? status}) {
    return OrderModel(
      id: id,
      userId: userId,
      items: items,
      total: total,
      status: status ?? this.status,
      createdAt: createdAt,
       customerName: customerName,
    phone: phone,              
    address: address,         
    city: city,  
    );
  }
}
