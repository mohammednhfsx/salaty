import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/cart/cart_controller.dart';
import 'package:salaty/controller/order_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ✅ طريقة الدفع المختارة
  final selectedPayment = 'cash'.obs; // cash | online

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final orders = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F8),
      appBar: AppBar(
        title: const Text(
          "إتمام الطلب",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ══════════════════════════
              // بيانات التوصيل
              // ══════════════════════════
              _sectionTitle("📦 بيانات التوصيل"),
              const SizedBox(height: 12),
              _buildCard(
                child: Column(
                  children: [
                    _field(
                      controller: nameCtrl,
                      label: "الاسم الكامل",
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? "مطلوب" : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: phoneCtrl,
                      label: "رقم الهاتف",
                      icon: Icons.phone_outlined,
                      type: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? "مطلوب" : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: cityCtrl,
                      label: "المدينة",
                      icon: Icons.location_city_outlined,
                      validator: (v) => v!.isEmpty ? "مطلوب" : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: addressCtrl,
                      label: "العنوان التفصيلي",
                      icon: Icons.home_outlined,
                      validator: (v) => v!.isEmpty ? "مطلوب" : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ══════════════════════════
              // طريقة الدفع
              // ══════════════════════════
              _sectionTitle("💳 طريقة الدفع"),
              const SizedBox(height: 12),

              Obx(
                () => Column(
                  children: [
                    // كاش
                    _PaymentOption(
                      value: 'cash',
                      selected: selectedPayment.value,
                      icon: Icons.payments_outlined,
                      title: "الدفع عند الاستلام",
                      subtitle: "ادفع كاش عند وصول طلبك",
                      color: Colors.green,
                      onTap: () => selectedPayment.value = 'cash',
                    ),
                    const SizedBox(height: 10),
                    // دفع إلكتروني
                    // _PaymentOption(
                    //   value: 'online',
                    //   selected: selectedPayment.value,
                    //   icon: Icons.credit_card_outlined,
                    //   title: "الدفع الإلكتروني",
                    //   subtitle: "ادفع الآن عبر بطاقة الائتمان",
                    //   color: Colors.blue,
                    //   onTap: () => selectedPayment.value = 'online',
                    // ),
                    _PaymentOption(
                      value: 'online',
                      selected: selectedPayment.value,
                      icon: Icons.credit_card_outlined,
                      title: "الدفع الإلكتروني",
                      subtitle: "قريباً — غير متاح حالياً",
                      color: Colors.grey,
                      onTap: () => Get.snackbar(
                        "قريباً 🔜",
                        "خدمة الدفع الإلكتروني ستكون متاحة قريباً",
                        backgroundColor: Colors.grey[800],
                        colorText: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ تفاصيل الدفع الإلكتروني
              Obx(
                () => selectedPayment.value == 'online'
                    ? _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "بيانات البطاقة",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _field(
                              controller: TextEditingController(),
                              label: "رقم البطاقة",
                              icon: Icons.credit_card,
                              type: TextInputType.number,
                              validator: (v) => v!.length < 16
                                  ? "رقم البطاقة غير صحيح"
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    controller: TextEditingController(),
                                    label: "MM/YY",
                                    icon: Icons.date_range_outlined,
                                    type: TextInputType.number,
                                    validator: (v) =>
                                        v!.isEmpty ? "مطلوب" : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _field(
                                    controller: TextEditingController(),
                                    label: "CVV",
                                    icon: Icons.lock_outline,
                                    type: TextInputType.number,
                                    validator: (v) =>
                                        v!.length < 3 ? "غير صحيح" : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: 20),

              // ══════════════════════════
              // ملخص الطلب
              // ══════════════════════════
              _sectionTitle("🧾 ملخص الطلب"),
              const SizedBox(height: 12),
              _buildCard(
                child: Obx(
                  () => Column(
                    children: [
                      _summaryRow(
                        "المنتجات",
                        "${cart.total.toStringAsFixed(0)} د.ع",
                      ),
                      const Divider(height: 16),
                      // _summaryRow(
                      //   "التوصيل",
                      //   "${cart.shoping.toStringAsFixed(0)} د.ع",
                      // ),
                      const Divider(height: 16),
                      _summaryRow(
                        "رسوم الخدمة (1%)",
                        "${(cart.finaltotal * 0.01).toStringAsFixed(0)} د.ع",
                        color: Colors.orange,
                      ),
                      const Divider(height: 16),
                      _summaryRow(
                        "المجموع الكلي",
                        "${cart.finaltotal.toStringAsFixed(0)} د.ع",
                        isBold: true,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ══════════════════════════
              // زر التأكيد
              // ══════════════════════════
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: orders.isLoading.value
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            // ✅ لو دفع إلكتروني — رسالة مؤقتة
                            if (selectedPayment.value == 'online') {
                              Get.snackbar(
                                "⏳ جاري المعالجة",
                                "يتم معالجة الدفع...",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                              await Future.delayed(const Duration(seconds: 2));
                            }

                            await orders.placeOrder(
                              cart,
                              name: nameCtrl.text,
                              phone: phoneCtrl.text,
                              address: addressCtrl.text,
                              city: cityCtrl.text,
                              paymentMethod: selectedPayment.value,
                            );
                          },
                    child: orders.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            selectedPayment.value == 'cash'
                                ? "✅ تأكيد الطلب"
                                : "💳 ادفع الآن",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _buildCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
      ],
    ),
    child: child,
  );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: type,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.teal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );

  Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBold ? 16 : 14,
          color: color ?? Colors.black87,
        ),
      ),
    ],
  );
}

// ══════════════════════════════════════
// Payment Option Widget
// ══════════════════════════════════════
class _PaymentOption extends StatelessWidget {
  final String value;
  final String selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.value,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
