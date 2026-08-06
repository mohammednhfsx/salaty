import 'package:get/get.dart';

import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/controller/admin_orders_controller.dart';


class AdminOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOrdersController>(
      () => AdminOrdersController(orderController: Get.find<OrderController>()),
    );
  }
}
