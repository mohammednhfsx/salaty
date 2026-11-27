import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/controller/admin_orders_controller.dart';
import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';
import 'package:salaty/core/features/admin_orders/widgets/admin_dashboard_shell.dart';
import 'package:salaty/core/features/admin_orders/widgets/orders_view.dart';

import 'package:salaty/models/order_model.dart';

class ReportsView extends GetView<AdminOrdersController> {
  const ReportsView({super.key, required this.showHeader});

  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader)
          const SimpleHeader(
            title: 'التقارير والإحصائيات',
            subtitle: 'ملخص أداء الطلبات والمبيعات',
          ),
        Expanded(
          child: Obx(() {
            final delivered = controller.deliveredOrders;

            return ListView(
              padding: const EdgeInsets.all(28),
              children: [
                OrdersStatsGrid(
                  all: controller.allCount,
                  pending: controller.pendingCount,
                  confirmed: controller.confirmedCount,
                  delivered: controller.deliveredCount,
                ),
                const SizedBox(height: 20),
                _MoneyCards(
                  totalSales: controller.totalSales,
                  totalProfit: controller.totalProfit,
                ),
                const SizedBox(height: 24),
                PremiumProfitCard(
                  totalProfit: controller.totalProfit,
                  sales7Days: controller.salesLast7Days,
                  profit7Days: controller.profitLast7Days,
                ),
                const SizedBox(height: 30),
                _DeliveredSectionHeader(count: delivered.length),
                const SizedBox(height: 16),
                if (delivered.isEmpty)
                  const _NoDeliveredOrders()
                else
                  ...delivered
                      .take(8)
                      .map(
                        (order) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: DeliveredOrderReportCard(order: order),
                        ),
                      ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _MoneyCards extends StatelessWidget {
  const _MoneyCards({required this.totalSales, required this.totalProfit});

  final double totalSales;
  final double totalProfit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final sales = MoneyReportCard(
          title: 'إجمالي المبيعات المكتملة',
          value: '${totalSales.toStringAsFixed(0)} د.ع',
          icon: Icons.payments_outlined,
          color: AdminOrdersPalette.confirmed,
        );
        final profit = MoneyReportCard(
          title: 'إجمالي ربح المنصة',
          value: '${totalProfit.toStringAsFixed(0)} د.ع',
          icon: Icons.account_balance_wallet_outlined,
          color: AdminOrdersPalette.primary,
        );

        if (compact) {
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

class MoneyReportCard extends StatelessWidget {
  const MoneyReportCard({
    super.key,
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
      padding: const EdgeInsets.all(24),
      decoration: adminCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF7B8495),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  style: const TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 23,
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

class PremiumProfitCard extends StatelessWidget {
  const PremiumProfitCard({
    super.key,
    required this.totalProfit,
    required this.sales7Days,
    required this.profit7Days,
  });

  final double totalProfit;
  final double sales7Days;
  final double profit7Days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30203A43),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'إجمالي أرباحك (1%)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${totalProfit.toStringAsFixed(0)} د.ع',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final sales = PremiumValue(
                  label: 'مبيعات آخر 7 أيام',
                  value: '${sales7Days.toStringAsFixed(0)} د.ع',
                );
                final profit = PremiumValue(
                  label: 'أرباح آخر 7 أيام',
                  value: '${profit7Days.toStringAsFixed(0)} د.ع',
                );

                if (constraints.maxWidth < 520) {
                  return Column(
                    children: [
                      sales,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Divider(
                          color: Colors.white.withOpacity(.15),
                          height: 1,
                        ),
                      ),
                      profit,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: sales),
                    Container(
                      width: 1,
                      height: 42,
                      color: Colors.white.withOpacity(.18),
                    ),
                    Expanded(child: profit),
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

class PremiumValue extends StatelessWidget {
  const PremiumValue({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DeliveredSectionHeader extends StatelessWidget {
  const _DeliveredSectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الطلبات المسلّمة',
                style: TextStyle(
                  color: AdminOrdersPalette.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'آخر الطلبات المكتملة مع بيانات العميل والمنتجات والأرباح',
                style: TextStyle(color: AdminOrdersPalette.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count طلب',
            style: const TextStyle(
              color: AdminOrdersPalette.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoDeliveredOrders extends StatelessWidget {
  const _NoDeliveredOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      decoration: adminCardDecoration(),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, color: Color(0xFFB6BFCC), size: 38),
          SizedBox(height: 12),
          Text(
            'لا توجد طلبات مسلّمة حتى الآن',
            style: TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveredOrderReportCard extends StatelessWidget {
  const DeliveredOrderReportCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: adminCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DeliveredCardHeader(order: order),
          const Divider(height: 1, color: Color(0xFFE9EDF2)),
          _DeliveredCustomerGrid(order: order),
          if (order.items.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFE9EDF2)),
            _DeliveredProducts(order: order),
          ],
          _DeliveredCardFooter(order: order),
        ],
      ),
    );
  }
}

class _DeliveredCardHeader extends StatelessWidget {
  const _DeliveredCardHeader({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: const Color(0xFFFAFCFD),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.done_all_rounded,
              color: AdminOrdersPalette.delivered,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب #${shortOrderId(order)}',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (order.createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    formatOrderDateTime(order.createdAt!),
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: AdminOrdersPalette.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order.total.toStringAsFixed(0)} د.ع',
                style: const TextStyle(
                  color: AdminOrdersPalette.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              OrderStatusBadge(status: orderStatusUi('delivered')),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveredCustomerGrid extends StatelessWidget {
  const _DeliveredCustomerGrid({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 900 ? 4 : (width >= 520 ? 2 : 1);
          const spacing = 16.0;
          final itemWidth = (width - (spacing * (columns - 1))) / columns;
          final address = [
            order.city,
            order.address,
          ].where((value) => value.trim().isNotEmpty).join('، ');

          return Wrap(
            spacing: spacing,
            runSpacing: 18,
            children: [
              SizedBox(
                width: itemWidth,
                child: ReportOrderInfo(
                  icon: Icons.person_outline_rounded,
                  label: 'اسم العميل',
                  value: order.customerName,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: ReportOrderInfo(
                  icon: Icons.phone_outlined,
                  label: 'رقم الهاتف',
                  value: order.phone,
                  ltr: true,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: ReportOrderInfo(
                  icon: Icons.location_on_outlined,
                  label: 'عنوان التوصيل',
                  value: address,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: ReportOrderInfo(
                  icon: Icons.inventory_2_outlined,
                  label: 'عدد المنتجات',
                  value: '${order.items.length} منتج',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DeliveredProducts extends StatelessWidget {
  const _DeliveredProducts({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المنتجات',
            style: TextStyle(
              color: Color(0xFF344054),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items
              .take(3)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      _ReportProductImage(imageUrl: item.image.toString()),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF344054),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'الكمية: ${item.quantity}',
                              style: const TextStyle(
                                color: AdminOrdersPalette.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(item.price * item.quantity).toStringAsFixed(0)} د.ع',
                        style: const TextStyle(
                          color: AdminOrdersPalette.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (order.items.length > 3)
            Text(
              '+ ${order.items.length - 3} منتجات أخرى',
              style: const TextStyle(
                color: AdminOrdersPalette.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeliveredCardFooter extends GetView<AdminOrdersController> {
  const _DeliveredCardFooter({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      color: const Color(0xFFFAFCFD),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ربح المنصة: ${controller.profitFor(order).toStringAsFixed(0)} د.ع',
              style: const TextStyle(
                color: AdminOrdersPalette.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => openOrderMap(order),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text('عرض الموقع'),
            style: TextButton.styleFrom(
              foregroundColor: AdminOrdersPalette.primary,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportOrderInfo extends StatelessWidget {
  const ReportOrderInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.ltr = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7F5),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AdminOrdersPalette.primary, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                value.trim().isEmpty ? 'غير متوفر' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: ltr ? TextDirection.ltr : null,
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportProductImage extends StatelessWidget {
  const _ReportProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.trim().isEmpty
            ? const Icon(Icons.inventory_2_outlined, color: Color(0xFF98A2B3))
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 120,
                cacheHeight: 120,
                filterQuality: FilterQuality.low,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Color(0xFF98A2B3),
                ),
              ),
      ),
    );
  }
}
