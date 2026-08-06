import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/admin_orders_controller.dart';

import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';

import 'package:salaty/models/order_model.dart';

class AdminOrderCard extends StatelessWidget {
  const AdminOrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1050) {
          return _DesktopOrderCard(order: order);
        }
        return _CompactOrderCard(order: order);
      },
    );
  }
}

class _DesktopOrderCard extends StatelessWidget {
  const _DesktopOrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isEmpty ? null : order.items.first;

    return Container(
      height: 180,
      decoration: adminCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 180, child: _OrderIdentity(order: order)),
          const _VerticalDivider(),
          SizedBox(width: 205, child: _CustomerInfo(order: order)),
          const _VerticalDivider(),
          Expanded(flex: 2, child: _LocationInfo(order: order)),
          const _VerticalDivider(),
          Expanded(
            flex: 3,
            child: _ProductSummary(order: order, firstItem: firstItem),
          ),
          const _VerticalDivider(),
          SizedBox(width: 230, child: _OrderStatusPanel(order: order)),
        ],
      ),
    );
  }
}

class _CompactOrderCard extends StatelessWidget {
  const _CompactOrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isEmpty ? null : order.items.first;
    final status = orderStatusUi(order.status);

    return Container(
      decoration: adminCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: status.color.withOpacity(.06),
            child: Row(
              children: [
                Expanded(child: _OrderIdentity(order: order, compact: true)),
                OrderStatusBadge(status: status),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _CustomerInfo(order: order, compact: true),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _LocationInfo(order: order, compact: true),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _CustomerInfo(order: order, compact: true),
                    const SizedBox(height: 16),
                    _LocationInfo(order: order, compact: true),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE9EDF2)),
          _ProductSummary(order: order, firstItem: firstItem, compact: true),
          const Divider(height: 1, color: Color(0xFFE9EDF2)),
          _OrderStatusPanel(order: order, compact: true),
        ],
      ),
    );
  }
}

class _OrderIdentity extends StatelessWidget {
  const _OrderIdentity({required this.order, this.compact = false});

  final OrderModel order;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = orderStatusUi(order.status);
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description_outlined, color: status.color, size: 17),
            const SizedBox(width: 7),
            const Text(
              'طلب',
              style: TextStyle(color: AdminOrdersPalette.muted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          '#${shortOrderId(order)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: AdminOrdersPalette.text,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (order.createdAt != null) ...[
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF98A2B3),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  formatOrderDateTime(order.createdAt!),
                  textDirection: TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7B8495),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    return compact
        ? content
        : Padding(padding: const EdgeInsets.all(18), child: content);
  }
}

class _CustomerInfo extends StatelessWidget {
  const _CustomerInfo({required this.order, this.compact = false});

  final OrderModel order;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.person_outline_rounded, text: 'العميل'),
        const SizedBox(height: 10),
        Text(
          order.customerName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AdminOrdersPalette.text,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            const Icon(
              Icons.phone_outlined,
              color: AdminOrdersPalette.primary,
              size: 17,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: SelectableText(
                order.phone,
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );

    return compact
        ? content
        : Padding(padding: const EdgeInsets.all(18), child: content);
  }
}

class _LocationInfo extends StatelessWidget {
  const _LocationInfo({required this.order, this.compact = false});

  final OrderModel order;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final address = [
      order.city,
      order.address,
    ].where((value) => value.trim().isNotEmpty).join('، ');

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.location_on_outlined, text: 'الموقع'),
        const SizedBox(height: 10),
        Text(
          address.isEmpty ? 'غير متوفر' : address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AdminOrdersPalette.text,
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 9),
        TextButton.icon(
          onPressed: () => openOrderMap(order),
          icon: const Icon(Icons.map_outlined, size: 18),
          label: const Text('عرض على الخريطة'),
          style: TextButton.styleFrom(
            foregroundColor: AdminOrdersPalette.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );

    return compact
        ? content
        : Padding(padding: const EdgeInsets.all(18), child: content);
  }
}

class _ProductSummary extends StatelessWidget {
  const _ProductSummary({
    required this.order,
    required this.firstItem,
    this.compact = false,
  });

  final OrderModel order;
  final dynamic firstItem;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? 16 : 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (firstItem == null)
            const Text('لا توجد منتجات في الطلب')
          else
            Row(
              children: [
                _ProductImage(imageUrl: firstItem.image.toString(), size: 58),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AdminOrdersPalette.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'الكمية: ${firstItem.quantity}',
                        style: const TextStyle(
                          color: Color(0xFF7B8495),
                          fontSize: 11,
                        ),
                      ),
                      if (order.items.length > 1) ...[
                        const SizedBox(height: 4),
                        Text(
                          '+ ${order.items.length - 1} منتجات أخرى',
                          style: const TextStyle(
                            color: AdminOrdersPalette.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.total.toStringAsFixed(0)} د.ع',
                  style: const TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'ربح المنصة: ${order.platformFee.toStringAsFixed(0)} د.ع',
                style: const TextStyle(
                  color: AdminOrdersPalette.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStatusPanel extends GetView<AdminOrdersController> {
  const _OrderStatusPanel({required this.order, this.compact = false});

  final OrderModel order;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentStatus = orderStatusUi(order.status);
      final selectedStatus = controller.selectedStatusFor(order);
      final updating = controller.isUpdating(order);

      return Container(
        color: compact ? const Color(0xFFFAFBFC) : Colors.white,
        padding: EdgeInsets.all(compact ? 16 : 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: OrderStatusBadge(status: currentStatus),
            ),
            const SizedBox(height: 10),
            const Text(
              'تغيير حالة الطلب',
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFD8DEE7)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  items: AdminOrdersController.supportedStatuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(orderStatusUi(status).label),
                        ),
                      )
                      .toList(),
                  onChanged: updating
                      ? null
                      : (value) {
                          if (value != null) {
                            controller.selectOrderStatus(order, value);
                          }
                        },
                ),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: controller.canUpdateStatus(order)
                    ? () => _confirmUpdate(context)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AdminOrdersPalette.primary,
                  disabledBackgroundColor: const Color(0xFFDDE3EA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: updating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('تحديث الحالة'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _confirmUpdate(BuildContext context) async {
    final status = orderStatusUi(controller.selectedStatusFor(order));
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'تأكيد تغيير الحالة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        content: Text('هل تريد تغيير حالة الطلب إلى "${status.label}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('تراجع'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: AdminOrdersPalette.primary,
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await controller.updateOrderStatus(order);
    } catch (_) {
      Get.snackbar(
        'تعذر تحديث الحالة',
        'تحقق من الاتصال وحاول مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: imageUrl.trim().isEmpty
            ? const Icon(Icons.inventory_2_outlined, color: Color(0xFF98A2B3))
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 160,
                cacheHeight: 160,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AdminOrdersPalette.muted, size: 17),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: AdminOrdersPalette.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: 18),
      color: const Color(0xFFE9EDF2),
    );
  }
}
