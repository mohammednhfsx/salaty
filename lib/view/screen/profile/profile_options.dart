import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/auth_controller.dart';
import 'package:salaty/controller/order_controller.dart';
import 'package:salaty/controller/profiles_controller.dart';
import 'package:salaty/core/constant/route.dart';
import 'package:salaty/core/localization/local_change.dart';
import 'package:salaty/core/services/location_service.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // ✅ Edit Profile — يفتح bottom sheet لتعديل الاسم
          buildItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            subtitle: "Update your personal information",
            onTap: () => _showEditProfile(context),
          ),
          // ✅ Order History — يروح لصفحة الطلبات
          buildItem(
            icon: Icons.inventory_2_outlined,
            title: "Order History",
            subtitle: "View all your past orders",
            onTap: () {
              Get.find<OrderController>().getMyOrders();
              Get.toNamed(AppRoutes.orders);
            },
          ),
          // ✅ Notifications — يفتح إعدادات الإشعارات
          buildItem(
            icon: Icons.notifications_none,
            title: "Notifications",
            subtitle: "Manage notification preferences",
            onTap: () => _showNotificationSettings(context),
          ),
          // ✅ Help & Support
          buildItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "Get help with your orders",
            onTap: () => _showHelpSupport(context),
          ),
          // ✅ Privacy Policy
          buildItem(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            subtitle: "View our privacy policy",
            isLast: true,
            onTap: () => _showPrivacyPolicy(context),
          ),
          buildItem(
            icon: Icons.location_on_outlined,
            title: "My Addresses",
            subtitle: "Manage your delivery addresses",
            onTap: () => _showAddresses(context),
          ),
           buildItem(
            icon: Icons.language,
            title: "language",
            subtitle: "Ghange language",
            onTap: () =>_showLanguageSheet(context), 
          ),
              buildItem(color: Colors.red,
            icon: Icons.logout_rounded,
            title: "Logout ",
            subtitle: "signout of account",
            onTap: () => _showLogoutDialog(context),
          ),
           
        ],
      ),
    );
  }

  Widget buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function() onTap,
    bool isLast = false,
    Color? color 

  }) { final itemColor = color ?? Colors.green;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: itemColor.withOpacity(0.1),
            child: Icon(icon, color: itemColor),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 2, thickness: 0.5, indent: 70),
      ],
    );
  }
}

// ════════════════════════════════════════════
//  Edit Profile — Bottom Sheet
// ليش Bottom Sheet وليس صفحة كاملة؟
// لأن التعديل بسيط (اسم فقط) — Bottom Sheet أسرع وأريح للمستخدم
// ════════════════════════════════════════════
void _showEditProfile(BuildContext context) {
  final ProfileController profileCtrl = Get.find<ProfileController>();
  final TextEditingController nameCtrl = TextEditingController(
    text: profileCtrl.userData['name'] ?? '',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // ✅ يتمدد مع الكيبورد
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      // ✅ viewInsets.bottom: يرفع الـ sheet فوق الكيبورد تلقائياً
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "  Edit Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ✅ حقل الاسم
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              labelText: " Full Name",
              prefixIcon: const Icon(Icons.person_outline, color: Colors.teal),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ✅ الإيميل — للعرض فقط (لا يمكن تغييره)
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: profileCtrl.userData['email'] ?? '',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              helperText: "The email address cannot be changed.",
            ),
          ),
          const SizedBox(height: 20),

          // ✅ زر الحفظ
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileCtrl.isLoading.value
                    ? null
                    : () async {
                        if (nameCtrl.text.trim().isEmpty) {
                          Get.snackbar("خطأ", "الاسم لا يمكن أن يكون فارغاً");
                          return;
                        }
                        await profileCtrl.updateName(nameCtrl.text.trim());
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: profileCtrl.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                    "Save changes",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ════════════════════════════════════════════
// ✅ Notification Settings
// ════════════════════════════════════════════
void _showNotificationSettings(BuildContext context) {
  // ✅ RxBool: قيم مراقَبة للـ switches
  final orderUpdates = true.obs;
  final promotions = false.obs;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Notification settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ✅ Obx على كل Switch منفصلاً
          Obx(
            () => SwitchListTile(
              activeThumbColor: Colors.teal,
              title: const Text(
               "Order Updates",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text("Receive notifications when your order status changes"),
              value: orderUpdates.value,
              onChanged: (val) => orderUpdates.value = val,
            ),
          ),

          const Divider(),

          Obx(
            () => SwitchListTile(
              activeThumbColor: Colors.teal,
              title: const Text(
                "Offers and discounts",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text("Receive notifications for special offers"),
              value: promotions.value,
              onChanged: (val) => promotions.value = val,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  "تم ✅",
                  "تم حفظ إعدادات الإشعارات",
                  backgroundColor: Colors.teal,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ════════════════════════════════════════════
// ✅ Help & Support
// ════════════════════════════════════════════
void _showHelpSupport(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
           "Assistance and support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _helpItem(Icons.phone_outlined, "Contact us", "07700000000", () {
         
          }),
          _helpItem(
            Icons.email_outlined,
           "e-mail",
            "support@salaty.com",() {
              
            },
          ),
          _helpItem(Icons.chat_bubble_outline, "WhatsApp", "Contact via WhatsApp", () {
               showModalBottomSheet(  context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),   child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Center(
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
               
                borderRadius: BorderRadius.circular(10),
              ),
              child:   InkWell(
              onTap: () {
                
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Container(
                  height:  20, 
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.teal,
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    "WhatsApp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ) ,
            ),
          ),])));
          }),
          _helpItem(
            Icons.quiz_outlined,
            "Frequently asked questions",
          "Check out the frequently asked questions.",() {
            
          },
          ),

          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

Widget _helpItem(
  IconData icon,
  String title,
  String subtitle,
  void Function()? onTap,
) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.teal.withOpacity(0.1),
      child: Icon(icon, color: Colors.teal, size: 20),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}

// ════════════════════════════════════════════
// ✅ Privacy Policy
// ════════════════════════════════════════════
Future<void> _showPrivacyPolicy(BuildContext context) async {
 

   showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      // ✅ DraggableScrollableSheet: يتمدد عند السحب لأعلى
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
            "privacy policy",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

           _policySection(
  "Data Collection",
  "We collect the information you provide directly, such as your name, email address, phone number, and address when creating an account or placing an order.",
),
_policySection(
  "Data Usage",
  "We use your data to process orders, send order updates, and improve our services. We do not sell your data to third parties.",
),
_policySection(
  "Data Protection",
  "We use Firebase by Google to securely store data. All data is encrypted and protected using modern security standards.",
),
_policySection(
  "Your Rights",
  "You have the right to request access to, update, or delete your data at any time by contacting us.",
),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

Widget _policySection(String title, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ مهم
      children: [
        Text(
          title,
          textAlign: TextAlign.start, // ✅ يخدم عربي + إنكليزي
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textAlign: TextAlign.start, // ✅ يخدم الاثنين
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.7, // ✅ spacing أحلى
          ),
        ),
      ],
    ),
  );
}

// ════════════════════════════════════════════
// ✅ Address Management
// ════════════════════════════════════════════
void _showAddresses(BuildContext context) {
  final ProfileController ctrl = Get.find<ProfileController>();
  ctrl.getAddresses();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle + Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My addresses",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddAddressDialog(context),
                      icon: const Icon(Icons.add, color: Colors.teal),
                      label: const Text(
                        "add",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),

          // قائمة العناوين
          Expanded(
            child: Obx(() {
              if (ctrl.addresses.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "No saved addresses",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: ctrl.addresses.length,
                itemBuilder: (context, index) {
                  final addr = ctrl.addresses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.withOpacity(0.1),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.teal,
                        ),
                      ),
                      title: Text(
                        addr['label'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${addr['city']} — ${addr['address']}\n${addr['phone']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "حذف العنوان",
                            middleText: "Do you want to delete this address?",
                            textConfirm: "delete",
                            textCancel: "cancel",
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red,
                            onConfirm: () {
                              Get.back();
                              ctrl.deleteAddress(addr['id']);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}

void _showAddAddressDialog(BuildContext context) {
  final labelCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final ProfileController ctrl = Get.find<ProfileController>();
  final isLocating = false.obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Add a new address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _addressField(
            labelCtrl,
            "Naming (e.g., home, work)",
            Icons.label_outline,
          ),
          const SizedBox(height: 10),
          _addressField(cityCtrl, "City", Icons.location_city_outlined),
          const SizedBox(height: 10),
          _addressField(addressCtrl, "Detailed address", Icons.home_outlined),
          const SizedBox(height: 10),
          _addressField(
            phoneCtrl,
           "phone number",
            Icons.phone_outlined,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          //  زر تحديد الموقع التلقائي
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLocating.value
                    ? null
                    : () async {
                        isLocating.value = true;
                        final loc = LocationService();
                        final position = await loc.getCurrentPosition();
                        if (position != null) {
                          final addr = await loc.getAddressFromPosition(
                            position,
                          );
                          if (addr != null) {
                            cityCtrl.text = addr['city'] ?? '';
                            addressCtrl.text = addr['address'] ?? '';
                          }
                        }
                        isLocating.value = false;
                      },
                icon: isLocating.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.teal,
                        ),
                      )
                    : const Icon(Icons.my_location, color: Colors.teal),
                label: Text(
                  isLocating.value
                      ? "Your location is being determined..."
                      : "Automatically locate me",
                  style: const TextStyle(color: Colors.teal),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (labelCtrl.text.isEmpty ||
                    cityCtrl.text.isEmpty ||
                    addressCtrl.text.isEmpty ||
                    phoneCtrl.text.isEmpty) {
                  Get.snackbar( "Error", "Please fill in all fields");
                  return;
                }
                Get.back(); // أغلق هذا الـ sheet
                ctrl.addAddress(
                  label: labelCtrl.text.trim(),
                  city: cityCtrl.text.trim(),
                  address: addressCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                );
              },
              child: const Text(
               "Save address",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _addressField(
  TextEditingController ctrl,
  String label,
  IconData icon, {
  TextInputType type = TextInputType.text,
}) {
  return TextField(
    controller: ctrl,
    keyboardType: type,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 1.5),
      ),
    ),
  );
}
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة في الأعلى لإعطاء طابع بصري
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: Colors.red, size: 40),
              ),
              SizedBox(height: 20),
              Text(
                "Log out",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to log out of your account?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  // زر الإلغاء
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  // زر تسجيل الخروج
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                      child: Text(
                        "exit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  
}
void _showLanguageSheet(BuildContext context) {
  final controller = Get.find<LocaleController>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangOption(
              value: 'ar',
              selected: controller.selectedLang.value,
              title: "العربية",
              subtitle: "Arabic",
              color: Colors.green,
              onTap: () => controller.changeLang("ar"),
            ),
            const SizedBox(height: 10),
            _LangOption(
              value: 'en',
              selected: controller.selectedLang.value,
              title: "English",
              subtitle: "الإنجليزية",
              color: Colors.blue,
              onTap: () => controller.changeLang("en"),
            ),
          ],
        ),
      ),
    ),
  );
}
class _LangOption extends StatelessWidget {
  final String value;
  final String selected;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LangOption({
    required this.value,
    required this.selected,
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
        ),
        child: Row(
          children: [
            Icon(Icons.language, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}


