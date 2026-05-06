import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/models/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  String? selectedFilter;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().getAllOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("لوحة الأدمن",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ctrl.getAllOrders(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long), text: "الطلبات"),
            Tab(icon: Icon(Icons.bar_chart), text: "الإحصائيات"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ══════════════════════════════
          // Tab 1 — الطلبات
          // ══════════════════════════════
          Column(
            children: [
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        onTap: () =>
                            setState(() => selectedFilter = 'pending'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: "تم التأكيد",
                        isSelected: selectedFilter == 'confirmed',
                        color: Colors.blue,
                        onTap: () =>
                            setState(() => selectedFilter = 'confirmed'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: "تم التسليم",
                        isSelected: selectedFilter == 'delivered',
                        color: Colors.green,
                        onTap: () =>
                            setState(() => selectedFilter = 'delivered'),
                      ),
                    ],
                  ),
                ),
              ),

              // إحصائيات سريعة
              Obx(() {
                final orders = ctrl.orders;
                final pending =
                    orders.where((o) => o.status == 'pending').length;
                final confirmed =
                    orders.where((o) => o.status == 'confirmed').length;
                final delivered =
                    orders.where((o) => o.status == 'delivered').length;

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    children: [
                      _StatItem(
                          label: "الكل",
                          count: orders.length,
                          color: Colors.grey),
                      _divider(),
                      _StatItem(
                          label: "انتظار",
                          count: pending,
                          color: Colors.orange),
                      _divider(),
                      _StatItem(
                          label: "مؤكد",
                          count: confirmed,
                          color: Colors.blue),
                      _divider(),
                      _StatItem(
                          label: "مسلّم",
                          count: delivered,
                          color: Colors.green),
                    ],
                  ),
                );
              }),

              Expanded(
                child: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
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
                          Icon(Icons.inbox_outlined,
                              size: 70, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            selectedFilter == null
                                ? "لا توجد طلبات"
                                : "لا توجد طلبات بهذه الحالة",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _AdminOrderCard(order: filtered[index]),
                  );
                }),
              ),
            ],
          ),

          // ══════════════════════════════
          // Tab 2 — الإحصائيات
          // ══════════════════════════════
          Obx(() {
            final orders = ctrl.orders;
            final delivered =
                orders.where((o) => o.status == 'delivered').toList();

            final totalSales =
                delivered.fold(0.0, (sum, o) => sum + o.total);
            final totalProfit =
                delivered.fold(0.0, (sum, o) => sum + (o.platformFee ?? o.total * 0.01));
            final totalOrders = orders.length;
            final deliveredCount = delivered.length;
            final pendingCount =
                orders.where((o) => o.status == 'pending').length;

            // إحصائيات آخر 7 أيام
            final now = DateTime.now();
            final last7 = delivered.where((o) =>
                o.createdAt != null &&
                now.difference(o.createdAt!).inDays <= 7).toList();
            final sales7 = last7.fold(0.0, (sum, o) => sum + o.total);
            final profit7 = last7.fold(
                0.0, (sum, o) => sum + (o.platformFee ?? o.total * 0.01));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📊 الإحصائيات العامة",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // بطاقات الإحصائيات
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _StatCard(
                        title: "إجمالي الطلبات",
                        value: "$totalOrders",
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: "طلبات مسلّمة",
                        value: "$deliveredCount",
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: "قيد الانتظار",
                        value: "$pendingCount",
                        icon: Icons.hourglass_empty,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: "إجمالي المبيعات",
                        value: "${totalSales.toStringAsFixed(0)} د.ع",
                        icon: Icons.attach_money,
                        color: Colors.teal,
                        small: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // بطاقة الأرباح
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F6E56), Color(0xFF1aab87)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.white70, size: 20),
                            SizedBox(width: 8),
                            Text("أرباحك (1%)",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${totalProfit.toStringAsFixed(0)} د.ع",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ProfitMini(
                                label: "آخر 7 أيام مبيعات",
                                value:
                                    "${sales7.toStringAsFixed(0)} د.ع"),
                            _ProfitMini(
                                label: "آخر 7 أيام أرباح",
                                value:
                                    "${profit7.toStringAsFixed(0)} د.ع"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // آخر 5 طلبات مسلّمة
                  if (delivered.isNotEmpty) ...[
                    const Text("📦 آخر الطلبات المسلّمة",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...delivered.take(5).map((o) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: Colors.teal, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(o.customerName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    Text(
                                      o.createdAt != null
                                          ? "${o.createdAt!.day}/${o.createdAt!.month}/${o.createdAt!.year}"
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${o.total.toStringAsFixed(0)} د.ع",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    "ربح: ${(o.platformFee ?? o.total * 0.01).toStringAsFixed(0)} د.ع",
                                    style: const TextStyle(
                                        color: Colors.teal, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            );
          }),
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
// بطاقة إحصائية
// ══════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool small;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: small ? 14 : 20,
                      color: Colors.black87)),
              Text(title,
                  style:
                      const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfitMini extends StatelessWidget {
  final String label;
  final String value;
  const _ProfitMini({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// كارت الطلب
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
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "طلب #${order.id!.substring(0, 8).toUpperCase()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      if (order.createdAt != null)
                        Text(
                          "${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}  ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusText,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _infoRow("الزبون", order.customerName),
                _infoRow("الهاتف", order.phone),
                _infoRow("العنوان", order.address),
                _infoRow("المدينة", order.city),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final query = Uri.encodeComponent(
                        '${order.city} ${order.address}');
                    final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=$query');
                    await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.teal.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_outlined,
                            color: Colors.teal, size: 18),
                        SizedBox(width: 6),
                        Text("عرض على الخريطة",
                            style: TextStyle(
                                color: Colors.teal, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              children: order.items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.grey, size: 18),
                                      )),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(item.name,
                                    style:
                                        const TextStyle(fontSize: 13))),
                            Text("×${item.quantity}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                                "${(item.price * item.quantity).toStringAsFixed(0)} د.ع",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          const Divider(height: 20, indent: 12, endIndent: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("المجموع",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${order.total.toStringAsFixed(0)} د.ع",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),

          // ربح المنصة
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ربحك (1%)",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "${(order.platformFee ?? order.total * 0.01).toStringAsFixed(0)} د.ع",
                  style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Row(
              children: [
                const Text("تغيير الحالة: ",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                _StatusButton(
                  label: "انتظار",
                  color: Colors.orange,
                  isActive: order.status == 'pending',
                  onTap: () =>
                      _confirmChange(ctrl, order.id!, 'pending'),
                ),
                const SizedBox(width: 6),
                _StatusButton(
                  label: "تأكيد",
                  color: Colors.blue,
                  isActive: order.status == 'confirmed',
                  onTap: () =>
                      _confirmChange(ctrl, order.id!, 'confirmed'),
                ),
                const SizedBox(width: 6),
                _StatusButton(
                  label: "تسليم",
                  color: Colors.green,
                  isActive: order.status == 'delivered',
                  onTap: () =>
                      _confirmChange(ctrl, order.id!, 'delivered'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Text("$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(value, textDirection: TextDirection.ltr)),
          ],
        ),
      );

  void _confirmChange(
      OrderController ctrl, String orderId, String newStatus) {
    if (order.status == newStatus) return;
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
// Widgets مساعدة
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(label,
            style: TextStyle(
                color: isActive ? Colors.white : color,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? color : color.withOpacity(0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}