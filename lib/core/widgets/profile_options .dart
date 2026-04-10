import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/view/screen/profile/edit_profile.dart';

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
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          buildItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            subtitle: "Update your personal information", onTap: () {Get.to(EditProfile());  },
          ),
          buildItem(
            icon: Icons.location_on_outlined,
            title: "Address Management",
            subtitle: "Manage your delivery addresses", onTap: () {  },
          ),
          buildItem(
            icon: Icons.credit_card,
            title: "Payment Methods",
            subtitle: "Manage your payment options", onTap: () {  },
          ),
          buildItem(
            icon: Icons.inventory_2_outlined,
            title: "Order History",
            subtitle: "View all your past orders", onTap: () {  },
          ),
          buildItem(
            icon: Icons.notifications_none,
            title: "Notifications",
            subtitle: "Manage notification preferences", onTap: () {  },
          ),
          buildItem(onTap: () {
            
          },
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "Get help with your orders",
          ),
          buildItem(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            subtitle: "View our privacy policy",
            isLast: true, onTap: () {  },
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
  }) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap
            // هنا تضيف التنقل
          
        ),

        // الخط الفاصل
        if (!isLast)
          const Divider(
            height: 2,
            thickness: 0.5,
          ),
      ],
    );
  }
}