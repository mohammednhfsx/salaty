import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/models/order_model.dart';

/// Presentation controller for the admin orders feature.
///
/// It owns screen state and derived values. Firestore/data access stays inside
/// [OrderController], while widgets only render values exposed by this class.
class AdminOrdersController extends GetxController {
  AdminOrdersController({required OrderController orderController})
    : _orderController = orderController;

  static const List<String> supportedStatuses = [
    'pending',
    'confirmed',
    'delivered',
  ];

  final OrderController _orderController;

  final TextEditingController searchTextController = TextEditingController();

  final RxnString selectedFilter = RxnString();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxString searchQuery = ''.obs;
  final RxInt selectedMenuIndex = 0.obs;

  final RxMap<String, String> _selectedStatusByOrder = <String, String>{}.obs;
  final RxSet<String> _updatingOrderIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(_syncSearchQuery);
    refreshOrders();
  }

  @override
  void onClose() {
    searchTextController
      ..removeListener(_syncSearchQuery)
      ..dispose();
    super.onClose();
  }

  bool get isLoading => _orderController.isLoading.value;

  List<OrderModel> get allOrders =>
      List<OrderModel>.unmodifiable(_orderController.orders);

  List<OrderModel> get filteredOrders {
    return allOrders
        .where((order) {
          final statusMatches =
              selectedFilter.value == null ||
              order.status == selectedFilter.value;

          final createdAt = order.createdAt;
          final date = selectedDate.value;
          final dateMatches =
              date == null ||
              (createdAt != null &&
                  createdAt.year == date.year &&
                  createdAt.month == date.month &&
                  createdAt.day == date.day);

          final query = searchQuery.value;
          if (query.isEmpty) return statusMatches && dateMatches;

          final itemNames = order.items.map((item) => item.name).join(' ');
          final searchableText = [
            order.id ?? '',
            order.customerName,
            order.phone,
            order.city,
            order.address,
            itemNames,
          ].join(' ').toLowerCase();

          return statusMatches && dateMatches && searchableText.contains(query);
        })
        .toList(growable: false);
  }

  List<OrderModel> get deliveredOrders {
    final result = allOrders
        .where((order) => order.status == 'delivered')
        .toList();

    result.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return result;
  }

  int get allCount => allOrders.length;
  int get pendingCount => _countStatus('pending');
  int get confirmedCount => _countStatus('confirmed');
  int get deliveredCount => _countStatus('delivered');

  bool get hasActiveFilters =>
      selectedFilter.value != null ||
      selectedDate.value != null ||
      searchQuery.value.isNotEmpty;

  double get totalSales =>
      deliveredOrders.fold<double>(0, (sum, order) => sum + order.total);

  double get totalProfit =>
      deliveredOrders.fold<double>(0, (sum, order) => sum + profitFor(order));

  List<OrderModel> get deliveredLast7Days {
    final now = DateTime.now();
    return deliveredOrders
        .where((order) {
          final createdAt = order.createdAt;
          if (createdAt == null) return false;

          final difference = now.difference(createdAt).inDays;
          return difference >= 0 && difference <= 7;
        })
        .toList(growable: false);
  }

  double get salesLast7Days =>
      deliveredLast7Days.fold<double>(0, (sum, order) => sum + order.total);

  double get profitLast7Days => deliveredLast7Days.fold<double>(
    0,
    (sum, order) => sum + profitFor(order),
  );

  double profitFor(OrderModel order) {
    return order.platformFee > 0 ? order.platformFee : order.total * 0.01;
  }

  Future<void> refreshOrders() {
    return Future<void>.sync(_orderController.getAllOrders);
  }

  void selectMenu(int index) => selectedMenuIndex.value = index;

  void setStatusFilter(String? status) => selectedFilter.value = status;

  void setDateFilter(DateTime? date) => selectedDate.value = date;

  void clearDateFilter() => selectedDate.value = null;

  void clearFilters() {
    selectedFilter.value = null;
    selectedDate.value = null;
    searchTextController.clear();
  }

  String selectedStatusFor(OrderModel order) {
    final key = _orderKey(order);
    final selected = _selectedStatusByOrder[key] ?? order.status;
    return supportedStatuses.contains(selected) ? selected : 'pending';
  }

  void selectOrderStatus(OrderModel order, String status) {
    if (!supportedStatuses.contains(status)) return;
    _selectedStatusByOrder[_orderKey(order)] = status;
  }

  bool canUpdateStatus(OrderModel order) {
    return order.id != null &&
        selectedStatusFor(order) != order.status &&
        !isUpdating(order);
  }

  bool isUpdating(OrderModel order) {
    return _updatingOrderIds.contains(_orderKey(order));
  }

  Future<void> updateOrderStatus(OrderModel order) async {
    final orderId = order.id;
    if (orderId == null || !canUpdateStatus(order)) return;

    final key = _orderKey(order);
    final newStatus = selectedStatusFor(order);
    _updatingOrderIds.add(key);

    try {
      await Future<void>.sync(
        () => _orderController.updateStatus(orderId, newStatus),
      );
      _selectedStatusByOrder.remove(key);
    } finally {
      _updatingOrderIds.remove(key);
    }
  }

  int _countStatus(String status) {
    return allOrders.where((order) => order.status == status).length;
  }

  String _orderKey(OrderModel order) {
    return order.id ?? 'local-${order.hashCode}';
  }

  void _syncSearchQuery() {
    searchQuery.value = searchTextController.text.trim().toLowerCase();
  }
}
