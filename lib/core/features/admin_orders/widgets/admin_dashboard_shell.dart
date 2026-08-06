import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/admin_orders_controller.dart';

import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';
import 'package:salaty/core/features/admin_orders/widgets/orders_search_field.dart';


class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.closeOnSelect = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool closeOnSelect;

  static const _items = <({String label, IconData icon})>[
    (label: 'الرئيسية', icon: Icons.home_outlined),
    (label: 'الطلبات', icon: Icons.receipt_long_outlined),
    (label: 'المنتجات', icon: Icons.inventory_2_outlined),
    (label: 'العملاء', icon: Icons.people_alt_outlined),
    (label: 'التقارير', icon: Icons.bar_chart_rounded),
    (label: 'الإعدادات', icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 60,
                  child: Image(
                    image: AssetImage('assets/images/logo12.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final selected = selectedIndex == index;

                  return Material(
                    color: selected
                        ? const Color(0xFFE9F7F5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (closeOnSelect) Navigator.of(context).pop();
                        onSelected(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: selected
                                  ? AdminOrdersPalette.primary
                                  : const Color(0xFF667085),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: selected
                                    ? AdminOrdersPalette.primary
                                    : const Color(0xFF374151),
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            TextButton.icon(
              onPressed: () {
                Get.snackbar(
                  'تسجيل الخروج',
                  'اربط الزر بدالة تسجيل الخروج الموجودة في AuthController',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('تسجيل الخروج'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(vertical: 22),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends GetView<AdminOrdersController> {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة الطلبات',
                  style: TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'عرض وإدارة جميع الطلبات في متجرك',
                  style: TextStyle(
                    color: AdminOrdersPalette.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 360, height: 46, child: OrdersSearchField()),
          const SizedBox(width: 14),
          Obx(
            () => controller.isLoading
                ? const _LoadingHeaderButton()
                : HeaderIconButton(
                    tooltip: 'تحديث الطلبات',
                    icon: Icons.refresh_rounded,
                    onTap: controller.refreshOrders,
                  ),
          ),
          const SizedBox(width: 8),
          const NotificationButton(),
          const SizedBox(width: 16),
          Container(width: 1, height: 38, color: const Color(0xFFE5E7EB)),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFE8F7F4),
            child: Icon(
              Icons.person_outline_rounded,
              color: AdminOrdersPalette.primary,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أدمن المنصة',
                style: TextStyle(
                  color: AdminOrdersPalette.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'مدير النظام',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleHeader extends StatelessWidget {
  const SimpleHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AdminOrdersPalette.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AdminOrdersPalette.muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: const Color(0xFF667085), size: 21),
          ),
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF667085),
            size: 24,
          ),
        ),
        Positioned(
          top: 3,
          right: 3,
          child: Container(
            width: 17,
            height: 17,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingHeaderButton extends StatelessWidget {
  const _LoadingHeaderButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AdminOrdersPalette.primary,
        ),
      ),
    );
  }
}
