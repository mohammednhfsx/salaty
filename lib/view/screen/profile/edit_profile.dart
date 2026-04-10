import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/profile_controller.dart';
import 'package:salaty/view/screen/profile/change.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(appBar: AppBar(title: Text("Edit Profile"),),
    
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            "assets/images/WhatsApp Image 2026-02-17 at 3.30.21 PM.jpeg",
                          ),
                        ),
                      ),
        ),
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 130),
           child: InkWell(onTap: () {
             
           },
             child: Container(height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.blue.withOpacity(0.1),),alignment:AlignmentGeometry.center ,
                      child: Text("Ghange photo",style: TextStyle(color: Colors.black,fontSize: 15,),),),
           ),
         ),
          

            const SizedBox(height: 16),
           
              
            

            /// 🔹 الحقول
           GetX<ProfileController>(
  builder: (controller) {
    return Column(
      children: [
        buildItem(
          context,
          "الاسم",
          controller.userData['name'] ?? '',
          Icons.person,
        ),
        buildItem(
          context,
          "البريد الالكتروني",
          controller.userData['email'] ?? '',
          Icons.email,
        ),
        buildItem(
          context,
          "رقم الهاتف",
          controller.userData['phone'] ?? '',
          Icons.phone,
        ),
      ],
    );
  },
),
          

            const Spacer(),

            /// ✏️ زر طلب تعديل
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: فتح صفحة تعديل
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "طلب تعديل المعلومات",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      );
    
  }

  /// 🧩 Widget للكارد
Widget buildItem(BuildContext context, String title, String value, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditProfilePage(
              title: title,
              initialValue: value,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const Icon(Icons.edit, size: 18)
          ],
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'edit_profile_page.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("حسابي"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [

//             /// 🟢 صورة
//             const CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage(
//                 "https://via.placeholder.com/150",
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// 🔹 الحقول
//             buildItem(context, "الاسم", "محمد علي", Icons.person),
//             buildItem(context, "البريد الالكتروني", "test@email.com", Icons.email),
//             buildItem(context, "رقم الهاتف", "07700000000", Icons.phone),
//             buildItem(context, "العنوان", "بغداد", Icons.location_on),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildItem(BuildContext context, String title, String value, IconData icon) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => EditProfilePage(
//               title: title,
//               initialValue: value,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, blurRadius: 5)
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.blue),
//             const SizedBox(width: 10),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 12, color: Colors.grey)),
//                   const SizedBox(height: 4),
//                   Text(value,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),

//             const Icon(Icons.edit, size: 18)
//           ],
//         ),
//       ),
//     );
//   }
// }





