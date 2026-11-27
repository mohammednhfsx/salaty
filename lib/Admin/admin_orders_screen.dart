import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/Admin/admin.dart';
import 'package:salaty/controller/admin_orders_controller.dart';
import 'package:salaty/core/features/admin_orders/utils/admin_orders_ui.dart';
import 'package:salaty/core/features/admin_orders/widgets/admin_dashboard_shell.dart';
import 'package:salaty/core/features/admin_orders/widgets/admin_home_view.dart';
import 'package:salaty/core/features/admin_orders/widgets/orders_view.dart';
import 'package:salaty/core/features/admin_orders/widgets/reports_view.dart';


class AdminOrdersScreen extends GetView<AdminOrdersController> {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1120;

          return Obx(() {
            if (isDesktop) {
              return Scaffold(
                backgroundColor: AdminOrdersPalette.background,
                body: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    AdminSidebar(
                      selectedIndex: controller.selectedMenuIndex.value,
                      onSelected: _onMenuSelected,
                    ),
                    Expanded(
                      child: _selectedPage(context, showDesktopHeader: true),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              backgroundColor: AdminOrdersPalette.background,
              drawer: Drawer(
                width: 270,
                child: AdminSidebar(
                  selectedIndex: controller.selectedMenuIndex.value,
                  closeOnSelect: true,
                  onSelected: _onMenuSelected,
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 1,
                title: Text(
                  _pageTitle(controller.selectedMenuIndex.value),
                  style: const TextStyle(
                    color: AdminOrdersPalette.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                actions: [
                  Obx(
                    () => IconButton(
                      tooltip: 'تحديث',
                      onPressed: controller.isLoading
                          ? null
                          : controller.refreshOrders,
                      icon: controller.isLoading
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AdminOrdersPalette.primary,
                              ),
                            )
                          : const Icon(
                              Icons.refresh_rounded,
                              color: AdminOrdersPalette.primary,
                            ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              body: _selectedPage(context, showDesktopHeader: false),
            );
          });
        },
      ),
    );
  }

  void _onMenuSelected(int index) {
    switch (index) {
      case 0:
      case 1:
      case 4:
        controller.selectMenu(index);
        return;
      case 2:
        Get.offAll(() => Admin());
        return;
      default:
        Get.snackbar(
          'تنبيه',
          'هذا القسم غير مربوط حالياً',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  Widget _selectedPage(
    BuildContext context, {
    required bool showDesktopHeader,
  }) {
    switch (controller.selectedMenuIndex.value) {
      case 0:
        return AdminHomeView(
          showHeader: showDesktopHeader,
          onOpenAdmin: () => Get.offAll(() => Admin()),
        );
      case 4:
        return ReportsView(showHeader: showDesktopHeader);
      default:
        return OrdersView(
          showDesktopHeader: showDesktopHeader,
          onPickDate: () => _pickDate(context),
        );
    }
  }

  String _pageTitle(int index) {
    switch (index) {
      case 0:
        return 'الرئيسية';
      case 4:
        return 'التقارير';
      default:
        return 'إدارة الطلبات';
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'اختر تاريخ الطلب',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (picked != null) controller.setDateFilter(picked);
  }
}
