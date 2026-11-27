import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/admin_orders_controller.dart';
import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';
import 'package:salaty/core/features/admin_orders/widgets/admin_dashboard_shell.dart';
import 'package:salaty/core/features/admin_orders/widgets/orders_view.dart';


class AdminHomeView extends GetView<AdminOrdersController> {
  const AdminHomeView({
    super.key,
    required this.showHeader,
    required this.onOpenAdmin,
  });

  final bool showHeader;
  final VoidCallback onOpenAdmin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader)
          const SimpleHeader(
            title: 'الرئيسية',
            subtitle: 'مرحباً بك، هذه نظرة سريعة على أداء متجرك',
          ),
        Expanded(
          child: Obx(
            () => RefreshIndicator(
              color: AdminOrdersPalette.primary,
              onRefresh: controller.refreshOrders,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  showHeader ? 28 : 16,
                  24,
                  showHeader ? 28 : 16,
                  32,
                ),
                children: [
                  _WelcomeCard(
                    onOpenAdmin: onOpenAdmin,
                    onOpenOrders: () => controller.selectMenu(1),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'نظرة سريعة',
                    subtitle: 'آخر تحديث لأعداد الطلبات وحالاتها',
                  ),
                  const SizedBox(height: 14),
                  OrdersStatsGrid(
                    all: controller.allCount,
                    pending: controller.pendingCount,
                    confirmed: controller.confirmedCount,
                    delivered: controller.deliveredCount,
                  ),
                  const SizedBox(height: 24),
                  _HomeSummaryGrid(
                    totalSales: controller.totalSales,
                    totalProfit: controller.totalProfit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.onOpenAdmin, required this.onOpenOrders});

  final VoidCallback onOpenAdmin;
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2B0F766E),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            left: -35,
            top: -60,
            child: _DecorativeCircle(size: 190),
          ),
          const Positioned(
            left: 130,
            bottom: -80,
            child: _DecorativeCircle(size: 150),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 720;
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.14),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'لوحة تحكم المتجر',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      compact
                          ? 'أهلاً بك في لوحة التحكم'
                          : 'أهلاً بك في لوحة تحكم متجرك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 24 : 30,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'تابع الطلبات والمبيعات، وانتقل إلى إدارة المنتجات من مكان واحد.',
                      style: TextStyle(
                        color: Color(0xFFD9FFFA),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          onPressed: onOpenAdmin,
                          icon: const Icon(Icons.arrow_back_rounded, size: 19),
                          label: const Text('الانتقال إلى الإدارة'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F766E),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: onOpenOrders,
                          icon: const Icon(
                            Icons.receipt_long_outlined,
                            size: 18,
                          ),
                          label: const Text('عرض الطلبات'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );

                if (compact) return content;

                return Row(
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 36),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.space_dashboard_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AdminOrdersPalette.text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: AdminOrdersPalette.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class _HomeSummaryGrid extends StatelessWidget {
  const _HomeSummaryGrid({required this.totalSales, required this.totalProfit});

  final double totalSales;
  final double totalProfit;

  @override
  Widget build(BuildContext context) {
    final sales = _SummaryCard(
      title: 'إجمالي المبيعات المكتملة',
      value: '${totalSales.toStringAsFixed(0)} د.ع',
      icon: Icons.payments_outlined,
      color: AdminOrdersPalette.confirmed,
    );
    final profit = _SummaryCard(
      title: 'إجمالي ربح المنصة',
      value: '${totalProfit.toStringAsFixed(0)} د.ع',
      icon: Icons.account_balance_wallet_outlined,
      color: AdminOrdersPalette.primary,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 680) {
          return Column(children: [sales, const SizedBox(height: 14), profit]);
        }

        return Row(
          children: [
            Expanded(child: sales),
            const SizedBox(width: 14),
            Expanded(child: profit),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: adminCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AdminOrdersPalette.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
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
