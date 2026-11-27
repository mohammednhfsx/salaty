import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salaty/controller/admin_orders_controller.dart';
import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';


class OrdersSearchField extends GetView<AdminOrdersController> {
  const OrdersSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller.searchTextController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'ابحث برقم الطلب أو اسم العميل أو الهاتف...',
          hintStyle: const TextStyle(color: Color(0xFFA0A8B7), fontSize: 12),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF667085),
          ),
          suffixIcon: controller.searchQuery.value.isEmpty
              ? null
              : IconButton(
                  onPressed: controller.searchTextController.clear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
          filled: true,
          fillColor: const Color(0xFFFAFBFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: AdminOrdersPalette.primary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
