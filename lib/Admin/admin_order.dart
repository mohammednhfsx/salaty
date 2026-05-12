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

  // 🎨 ألوان النظام الأساسية
  static const Color primaryColor = Color(0xFF009688); // Teal
  static const Color bgColor = Color(0xFFF5F7FA);
  
  static const Color pendingColor = Color(0xFFF59E0B); // Amber
  static const Color confirmedColor = Color(0xFF3B82F6); // Blue
  static const Color deliveredColor = Color(0xFF10B981); // Emerald

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
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إدارة الطلبات",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: primaryColor),
            onPressed: () => ctrl.getAllOrders(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_rounded), text: "الطلبات"),
            Tab(icon: Icon(Icons.bar_chart_rounded), text: "الإحصائيات"),
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
              // ── شريط الفلاتر ──
              Container(
                color: Colors.white,
                height: 65,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterChip(
                      label: "الكل",
                      isSelected: selectedFilter == null,
                      color: Colors.grey.shade700,
                      onTap: () => setState(() => selectedFilter = null),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: "قيد الانتظار",
                      isSelected: selectedFilter == 'pending',
                      color: pendingColor,
                      onTap: () => setState(() => selectedFilter = 'pending'),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: "تم التأكيد",
                      isSelected: selectedFilter == 'confirmed',
                      color: confirmedColor,
                      onTap: () => setState(() => selectedFilter = 'confirmed'),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: "تم التسليم",
                      isSelected: selectedFilter == 'delivered',
                      color: deliveredColor,
                      onTap: () => setState(() => selectedFilter = 'delivered'),
                    ),
                  ],
                ),
              ),

              // ── إحصائيات سريعة ──
              Obx(() {
                final orders = ctrl.orders;
                final pending = orders.where((o) => o.status == 'pending').length;
                final confirmed = orders.where((o) => o.status == 'confirmed').length;
                final delivered = orders.where((o) => o.status == 'delivered').length;

                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      // ignore: deprecated_member_use
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: "الكل", count: orders.length, color: Colors.grey.shade700),
                      _divider(),
                      _StatItem(label: "انتظار", count: pending, color: pendingColor),
                      _divider(),
                      _StatItem(label: "مؤكد", count: confirmed, color: confirmedColor),
                      _divider(),
                      _StatItem(label: "مسلّم", count: delivered, color: deliveredColor),
                    ],
                  ),
                );
              }),

              // ── قائمة الطلبات ──
              Expanded(
                child: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: primaryColor));
                  }
                  final filtered = selectedFilter == null
                      ? ctrl.orders
                      : ctrl.orders.where((o) => o.status == selectedFilter).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            selectedFilter == null ? "لا توجد طلبات حتى الآن" : "لا توجد طلبات بهذه الحالة",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _AdminOrderCard(order: filtered[index]),
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
            final delivered = orders.where((o) => o.status == 'delivered').toList();

            final totalSales = delivered.fold(0.0, (sum, o) => sum + o.total);
            final totalProfit = delivered.fold(0.0, (sum, o) => sum + o.platformFee);
            final totalOrders = orders.length;
            final deliveredCount = delivered.length;
            final pendingCount = orders.where((o) => o.status == 'pending').length;

            final now = DateTime.now();
            final last7 = delivered.where((o) =>
                o.createdAt != null && now.difference(o.createdAt!).inDays <= 7).toList();
            final sales7 = last7.fold(0.0, (sum, o) => sum + o.total);
            final profit7 = last7.fold(0.0, (sum, o) => sum + o.platformFee);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📊 الإحصائيات العامة",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),

                  // ── بطاقات الإحصائيات ──
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
                        color: confirmedColor,
                      ),
                      _StatCard(
                        title: "طلبات مسلّمة",
                        value: "$deliveredCount",
                        icon: Icons.check_circle_outline,
                        color: deliveredColor,
                      ),
                      _StatCard(
                        title: "قيد الانتظار",
                        value: "$pendingCount",
                        icon: Icons.hourglass_empty_rounded,
                        color: pendingColor,
                      ),
                      _StatCard(
                        title: "إجمالي المبيعات",
                        value: "${totalSales.toStringAsFixed(0)} د.ع",
                        icon: Icons.attach_money_rounded,
                        color: primaryColor,
                        small: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── بطاقة الأرباح (Premium Design) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)], // Premium Dark
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        // ignore: deprecated_member_use
                        BoxShadow(color: const Color(0xFF203A43).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text("إجمالي أرباحك (1%)", style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "${totalProfit.toStringAsFixed(0)} د.ع",
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            // ignore: deprecated_member_use
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ProfitMini(label: "مبيعات 7 أيام", value: "${sales7.toStringAsFixed(0)} د.ع"),
                              // ignore: deprecated_member_use
                              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                              _ProfitMini(label: "أرباح 7 أيام", value: "${profit7.toStringAsFixed(0)} د.ع"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── آخر الطلبات المسلّمة ──
                  if (delivered.isNotEmpty) ...[
                    const Text("📦 آخر الطلبات المسلّمة",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 16),
                    ...delivered.take(5).map((o) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: [
                              // ignore: deprecated_member_use
                              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: deliveredColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle_outline, color: deliveredColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(o.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text(
                                      o.createdAt != null
                                          ? "${o.createdAt!.day}/${o.createdAt!.month}/${o.createdAt!.year}"
                                          : "",
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${o.total.toStringAsFixed(0)} د.ع",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "ربح: ${o.platformFee.toStringAsFixed(0)}",
                                      style: const TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
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
        height: 35,
        color: Colors.grey.shade200,
      );
}

// ══════════════════════════════════════════════
// كارت الإحصائيات (Grid)
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: small ? 15 : 22,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
              ),
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
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// كارت الطلب المطور
// ══════════════════════════════════════════════
class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  const _AdminOrderCard({required this.order});

  Color get statusColor {
    switch (order.status) {
      case 'confirmed': return const Color(0xFF3B82F6);
      case 'delivered': return const Color(0xFF10B981);
      default: return const Color(0xFFF59E0B);
    }
  }

  String get statusText {
    switch (order.status) {
      case 'confirmed': return 'تم التأكيد';
      case 'delivered': return 'تم التسليم';
      default: return 'قيد الانتظار';
    }
  }

  IconData get statusIcon {
    switch (order.status) {
      case 'confirmed': return Icons.check_circle_outline;
      case 'delivered': return Icons.done_all_rounded;
      default: return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OrderController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── رأس البطاقة ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: statusColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              // ignore: deprecated_member_use
              border: Border(bottom: BorderSide(color: statusColor.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: statusColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "طلب #${order.id!.substring(0, 8).toUpperCase()}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                      ),
                      if (order.createdAt != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          "${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year} • ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ── معلومات الزبون ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildInfoItem(Icons.person_outline, "الزبون", order.customerName),
                          const SizedBox(height: 12),
                          _buildInfoItem(Icons.location_city_outlined, "المدينة", order.city),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildInfoItem(Icons.phone_outlined, "الهاتف", order.phone, isLtr: true),
                          const SizedBox(height: 12),
                          _buildInfoItem(Icons.home_outlined, "العنوان", order.address),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final query = Uri.encodeComponent('${order.city} ${order.address}');
                      final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text("عرض الموقع على الخريطة", style: TextStyle(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF009688),
                      // ignore: deprecated_member_use
                      side: BorderSide(color: const Color(0xFF009688).withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // ── المنتجات المطلوبة ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("المنتجات", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 12),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.image, 
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text("الكمية: ${item.quantity}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        "${(item.price * item.quantity).toStringAsFixed(0)} د.ع",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF009688)),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),

          // ── الإجمالي والعمليات ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("الإجمالي:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                      "${order.total.toStringAsFixed(0)} د.ع",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ربح المنصة (1%):", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(
                      "${order.platformFee.toStringAsFixed(0)} د.ع",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF009688)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // أزرار تغيير الحالة
                Row(
                  children: [
                    Expanded(child: _StatusButton(
                      label: "انتظار", 
                      color: const Color(0xFFF59E0B), 
                      isActive: order.status == 'pending', 
                      onTap: () => _confirmChange(ctrl, order.id!, 'pending')
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _StatusButton(
                      label: "تأكيد", 
                      color: const Color(0xFF3B82F6), 
                      isActive: order.status == 'confirmed', 
                      onTap: () => _confirmChange(ctrl, order.id!, 'confirmed')
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _StatusButton(
                      label: "تسليم", 
                      color: const Color(0xFF10B981), 
                      isActive: order.status == 'delivered', 
                      onTap: () => _confirmChange(ctrl, order.id!, 'delivered')
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {bool isLtr = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              Text(
                value, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                textDirection: isLtr ? TextDirection.ltr : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmChange(OrderController ctrl, String orderId, String newStatus) {
    if (order.status == newStatus) return;
    final labels = {
      'pending': 'قيد الانتظار',
      'confirmed': 'تم التأكيد',
      'delivered': 'تم التسليم',
    };
    Get.defaultDialog(
      title: "تأكيد التغيير",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: "هل أنت متأكد من تغيير حالة الطلب إلى\n\"${labels[newStatus]}\"؟",
      middleTextStyle: const TextStyle(fontSize: 14, height: 1.5),
      textConfirm: "تأكيد",
      textCancel: "تراجع",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black87,
      buttonColor: const Color(0xFF009688),
      radius: 16,
      contentPadding: const EdgeInsets.all(20),
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
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          border: Border.all(color: isActive ? color : color.withOpacity(0.3), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : color,
            fontSize: 13,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
          boxShadow: isSelected ? [
            // ignore: deprecated_member_use
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))
          ] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 14,
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

  const _StatItem({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
