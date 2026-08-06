import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/controller/admin_orders_controller.dart';
import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';
import 'package:salaty/core/features/admin_orders/widgets/admin_dashboard_shell.dart';
import 'package:salaty/core/features/admin_orders/widgets/order_card.dart';
import 'package:salaty/core/features/admin_orders/widgets/orders_search_field.dart';


class OrdersView extends GetView<AdminOrdersController> {
  const OrdersView({
    super.key,
    required this.showDesktopHeader,
    required this.onPickDate,
  });

  final bool showDesktopHeader;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDesktopHeader) const DashboardHeader(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading && controller.allOrders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AdminOrdersPalette.primary,
                ),
              );
            }

            final orders = controller.filteredOrders;

            return RefreshIndicator(
              color: AdminOrdersPalette.primary,
              onRefresh: controller.refreshOrders,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: _sectionPadding(top: 24),
                    sliver: SliverToBoxAdapter(
                      child: OrdersStatsGrid(
                        all: controller.allCount,
                        pending: controller.pendingCount,
                        confirmed: controller.confirmedCount,
                        delivered: controller.deliveredCount,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: _sectionPadding(top: 20),
                    sliver: SliverToBoxAdapter(
                      child: OrdersToolbar(onPickDate: onPickDate),
                    ),
                  ),
                  if (orders.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyOrdersState(
                        hasFilters: controller.hasActiveFilters,
                        onClearFilters: controller.clearFilters,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: _sectionPadding(top: 18, bottom: 32),
                      sliver: SliverList.separated(
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return AdminOrderCard(
                            key: ValueKey(order.id ?? index),
                            order: order,
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  EdgeInsets _sectionPadding({required double top, double bottom = 0}) {
    final horizontal = showDesktopHeader ? 28.0 : 16.0;
    return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
  }
}

class OrdersStatsGrid extends StatelessWidget {
  const OrdersStatsGrid({
    super.key,
    required this.all,
    required this.pending,
    required this.confirmed,
    required this.delivered,
  });

  final int all;
  final int pending;
  final int confirmed;
  final int delivered;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatData(
        title: 'كل الطلبات',
        value: all,
        icon: Icons.receipt_long_outlined,
        color: AdminOrdersPalette.primary,
      ),
      _StatData(
        title: 'قيد الانتظار',
        value: pending,
        icon: Icons.schedule_rounded,
        color: AdminOrdersPalette.pending,
      ),
      _StatData(
        title: 'تم التأكيد',
        value: confirmed,
        icon: Icons.check_circle_outline_rounded,
        color: AdminOrdersPalette.confirmed,
      ),
      _StatData(
        title: 'تم التسليم',
        value: delivered,
        icon: Icons.local_shipping_outlined,
        color: AdminOrdersPalette.delivered,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000 ? 4 : (width >= 520 ? 2 : 1);
        final ratio = width >= 1000 ? 2.45 : (width >= 520 ? 2.1 : 3.0);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: ratio,
          ),
          itemBuilder: (context, index) => _StatCard(data: cards[index]),
        );
      },
    );
  }
}

class OrdersToolbar extends GetView<AdminOrdersController> {
  const OrdersToolbar({super.key, required this.onPickDate});

  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;
          final filters = const StatusFilters();
          final dateButton = DateFilterButton(onTap: onPickDate);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const OrdersSearchField(),
                const SizedBox(height: 14),
                filters,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: dateButton),
              ],
            );
          }

          return Row(
            children: [
              const Expanded(flex: 4, child: OrdersSearchField()),
              const SizedBox(width: 16),
              const Expanded(flex: 5, child: StatusFilters()),
              const SizedBox(width: 14),
              dateButton,
            ],
          );
        },
      ),
    );
  }
}

class StatusFilters extends GetView<AdminOrdersController> {
  const StatusFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          StatusFilterChip(
            label: 'الكل',
            color: AdminOrdersPalette.primary,
            selected: controller.selectedFilter.value == null,
            onTap: () => controller.setStatusFilter(null),
          ),
          StatusFilterChip(
            label: 'قيد الانتظار',
            color: AdminOrdersPalette.pending,
            selected: controller.selectedFilter.value == 'pending',
            onTap: () => controller.setStatusFilter('pending'),
          ),
          StatusFilterChip(
            label: 'تم التأكيد',
            color: AdminOrdersPalette.confirmed,
            selected: controller.selectedFilter.value == 'confirmed',
            onTap: () => controller.setStatusFilter('confirmed'),
          ),
          StatusFilterChip(
            label: 'تم التسليم',
            color: AdminOrdersPalette.delivered,
            selected: controller.selectedFilter.value == 'delivered',
            onTap: () => controller.setStatusFilter('delivered'),
          ),
        ],
      ),
    );
  }
}

class StatusFilterChip extends StatelessWidget {
  const StatusFilterChip({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color.withOpacity(.10) : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? color : const Color(0xFFDDE3EA),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != 'الكل') ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : const Color(0xFF667085),
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateFilterButton extends GetView<AdminOrdersController> {
  const DateFilterButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final date = controller.selectedDate.value;
      final label = date == null
          ? 'تاريخ الطلب'
          : '${date.day}/${date.month}/${date.year}';

      return Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDE3EA)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.calendar_month_outlined, size: 18),
              label: Text(label),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF475467),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                tooltip: 'إلغاء فلتر التاريخ',
                visualDensity: VisualDensity.compact,
                onPressed: controller.clearDateFilter,
                icon: const Icon(Icons.close_rounded, size: 17),
              ),
          ],
        ),
      );
    });
  }
}

class EmptyOrdersState extends StatelessWidget {
  const EmptyOrdersState({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
  });

  final bool hasFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                color: AdminOrdersPalette.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              hasFilters ? 'لا توجد نتائج مطابقة' : 'لا توجد طلبات حتى الآن',
              style: const TextStyle(
                color: Color(0xFF344054),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasFilters
                  ? 'جرّب تغيير البحث أو الفلاتر المستخدمة'
                  : 'ستظهر الطلبات الجديدة هنا تلقائياً',
              style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
            ),
            if (hasFilters) ...[
              const SizedBox(height: 14),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('مسح الفلاتر'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatData {
  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: adminCardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF7B8495),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.value.toString(),
                      style: TextStyle(
                        color: data.color,
                        fontSize: 27,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'طلب',
                      style: TextStyle(color: Color(0xFF98A2B3), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: data.color.withOpacity(.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(data.icon, color: data.color, size: 26),
          ),
        ],
      ),
    );
  }
}
