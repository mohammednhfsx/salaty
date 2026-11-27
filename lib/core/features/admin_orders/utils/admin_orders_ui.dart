import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/models/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class AdminOrdersPalette {
  static const primary = Color(0xFF0F9D8A);
  static const background = Color(0xFFF6F8FB);
  static const text = Color(0xFF111827);
  static const muted = Color(0xFF8A94A6);
  static const border = Color(0xFFE6EAF0);
  static const pending = Color(0xFFF59E0B);
  static const confirmed = Color(0xFF3B82F6);
  static const delivered = Color(0xFF10B981);
}

class OrderStatusUi {
  const OrderStatusUi({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

OrderStatusUi orderStatusUi(String status) {
  switch (status) {
    case 'confirmed':
      return const OrderStatusUi(
        label: 'تم التأكيد',
        color: AdminOrdersPalette.confirmed,
        icon: Icons.check_circle_outline_rounded,
      );
    case 'delivered':
      return const OrderStatusUi(
        label: 'تم التسليم',
        color: AdminOrdersPalette.delivered,
        icon: Icons.done_all_rounded,
      );
    default:
      return const OrderStatusUi(
        label: 'قيد الانتظار',
        color: AdminOrdersPalette.pending,
        icon: Icons.schedule_rounded,
      );
  }
}

BoxDecoration adminCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AdminOrdersPalette.border),
    boxShadow: const [
      BoxShadow(color: Color(0x07101828), blurRadius: 10, offset: Offset(0, 4)),
    ],
  );
}

String shortOrderId(OrderModel order) {
  final id = order.id ?? '';
  if (id.isEmpty) return 'غير متوفر';
  final end = id.length < 8 ? id.length : 8;
  return id.substring(0, end).toUpperCase();
}

String formatOrderDateTime(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/${date.year} - $hour:$minute';
}

Future<void> openOrderMap(OrderModel order) async {
  final query = Uri.encodeComponent('${order.city} ${order.address}'.trim());
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$query',
  );

  final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
  if (!opened) {
    Get.snackbar(
      'تعذر فتح الخريطة',
      'تحقق من العنوان وحاول مرة أخرى',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatusUi status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 15),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
