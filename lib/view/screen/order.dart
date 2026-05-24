import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/models/order_model.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();

    // ✅ الإصلاح: ننتظر حتى ينتهي الـ build الحالي ثم نحمّل الطلبات
    // ليش؟ لأن placeOrder() تستدعي getMyOrders() أثناء الانتقال للصفحة
    // وعندما تفتح الصفحة تستدعيها مرة ثانية — يصير تعارض
    // addPostFrameCallback: "بعد ما تنتهي من بناء الـ frame الحالي، نفّذ هذا"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().getMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderController ctrl = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.homepage);
          },
          icon: Icon(Icons.arrow_back),
        ),

        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "My_requests".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ctrl.getMyOrders(),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "No_orders_yet".tr,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                 Text(
               "Buy_something_to_show_up_here".tr,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: ctrl.orders.length,
          itemBuilder: (context, index) {
            return _OrderCard(order: ctrl.orders[index]);
          },
        );
      }),
    );
  }
}

// ================= كارت الطلب =================
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color get statusColor {
    switch (order.status) {
      case 'confirmed':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String get statusText {
    switch (order.status) {
      case 'confirmed':
        return 'Confirmed'.tr;
      case 'delivered':
        return 'Delivered'.tr;
      default:
        return 'pending'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          // ── Header: رقم الطلب + الحالة ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "order #${order.id!.substring(0, 8).toUpperCase()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── المنتجات + المجموع ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 45,
                              height: 45,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          "×${item.quantity}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(item.price * item.quantity).toStringAsFixed(0)} د.ع",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${order.total.toStringAsFixed(0)} د.ع",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                if (order.createdAt != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
