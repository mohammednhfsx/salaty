import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/models/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // ✅ فلتر الحالة المختارة — null = كل الطلبات
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    // ✅ الأدمن يجيب كل الطلبات (getAllOrders) مو بس طلباته
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "إدارة الطلبات",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // ✅ زر تحديث
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ctrl.getAllOrders(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ══════════════════════════════
          // ✅ شريط الفلتر بالحالة
          // ══════════════════════════════
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: "الكل",
                    isSelected: selectedFilter == null,
                    color: Colors.grey,
                    onTap: () => setState(() => selectedFilter = null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "قيد الانتظار",
                    isSelected: selectedFilter == 'pending',
                    color: Colors.orange,
                    onTap: () => setState(() => selectedFilter = 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "تم التأكيد",
                    isSelected: selectedFilter == 'confirmed',
                    color: Colors.blue,
                    onTap: () => setState(() => selectedFilter = 'confirmed'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: "تم التسليم",
                    isSelected: selectedFilter == 'delivered',
                    color: Colors.green,
                    onTap: () => setState(() => selectedFilter = 'delivered'),
                  ),
                ],
              ),
            ),
          ),

          // ══════════════════════════════
          // ✅ إحصائيات سريعة
          // ══════════════════════════════
          Obx(() {
            final orders = ctrl.orders;
            final pending = orders.where((o) => o.status == 'pending').length;
            final confirmed = orders
                .where((o) => o.status == 'confirmed')
                .length;
            final delivered = orders
                .where((o) => o.status == 'delivered')
                .length;

            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  _StatItem(
                    label: "الكل",
                    count: orders.length,
                    color: Colors.grey,
                  ),
                  _divider(),
                  _StatItem(
                    label: "انتظار",
                    count: pending,
                    color: Colors.orange,
                  ),
                  _divider(),
                  _StatItem(
                    label: "مؤكد",
                    count: confirmed,
                    color: Colors.blue,
                  ),
                  _divider(),
                  _StatItem(
                    label: "مسلّم",
                    count: delivered,
                    color: Colors.green,
                  ),
                ],
              ),
            );
          }),

          // ══════════════════════════════
          // ✅ قائمة الطلبات
          // ══════════════════════════════
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // ✅ تطبيق الفلتر
              final filtered = selectedFilter == null
                  ? ctrl.orders
                  : ctrl.orders
                        .where((o) => o.status == selectedFilter)
                        .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 70,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        selectedFilter == null
                            ? "لا توجد طلبات"
                            : "لا توجد طلبات بهذه الحالة",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _AdminOrderCard(order: filtered[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 30,
    color: Colors.grey[200],
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );
}

// ══════════════════════════════════════════════
// ✅ كارت الطلب — مع أزرار تغيير الحالة
// ══════════════════════════════════════════════
class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  const _AdminOrderCard({required this.order});

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
        return 'تم التأكيد';
      case 'delivered':
        return 'تم التسليم';
      default:
        return 'قيد الانتظار';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // رقم الطلب
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "طلب #${order.id!.substring(0, 8).toUpperCase()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (order.createdAt != null)
                        Text(
                          "${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}  ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                // الحالة الحالية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
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
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "الزبون: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Expanded(
                      child: Text(
                        order.customerName,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("الهاتف: "),
                    Expanded(
                      child: Text(
                        order.phone,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("العنوان: "),
                    Expanded(
                      child: Text(
                        order.address,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("المدينة: "),
                    Expanded(
                      child: Text(order.city, textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── المنتجات ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(
              children: order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 18,
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
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${(item.price * item.quantity).toStringAsFixed(0)} د.ع",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const Divider(height: 20, indent: 12, endIndent: 12),

          // ── المجموع ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "المجموع",
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
          ),

          const SizedBox(height: 12),

          // ══════════════════════════════
          // ✅ أزرار تغيير الحالة
          // ليش 3 أزرار؟ لأن الحالات 3: pending → confirmed → delivered
          // الزر المحدد يكون معطّل (لا تعيد تحديد نفس الحالة)
          // ══════════════════════════════
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Row(
              children: [
                const Text(
                  "تغيير الحالة: ",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                _StatusButton(
                  label: "انتظار",
                  color: Colors.orange,
                  isActive: order.status == 'pending',
                  onTap: () => _confirmChange(ctrl, order.id!, 'pending'),
                ),
                const SizedBox(width: 6),
                _StatusButton(
                  label: "تأكيد",
                  color: Colors.blue,
                  isActive: order.status == 'confirmed',
                  onTap: () => _confirmChange(ctrl, order.id!, 'confirmed'),
                ),
                const SizedBox(width: 6),
                _StatusButton(
                  label: "تسليم",
                  color: Colors.green,
                  isActive: order.status == 'delivered',
                  onTap: () => _confirmChange(ctrl, order.id!, 'delivered'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ نطلب تأكيد قبل تغيير الحالة — منعاً للأخطاء العرضية
  void _confirmChange(OrderController ctrl, String orderId, String newStatus) {
    if (order.status == newStatus) return; // نفس الحالة — ما نسوي شي

    final labels = {
      'pending': 'قيد الانتظار',
      'confirmed': 'تم التأكيد',
      'delivered': 'تم التسليم',
    };

    Get.defaultDialog(
      title: "تأكيد التغيير",
      middleText: "تغيير حالة الطلب إلى \"${labels[newStatus]}\"؟",
      textConfirm: "نعم",
      textCancel: "لا",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        Get.back();
        ctrl.updateStatus(orderId, newStatus);
      },
    );
  }
}

// ══════════════════════════════════════════════
// Widgets مساعدة صغيرة
// ══════════════════════════════════════════════

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
