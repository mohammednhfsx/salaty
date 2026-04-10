import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String title;
  final String initialValue;

  const EditProfilePage({
    super.key,
    required this.title,
    required this.initialValue,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل ${widget.title}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ✏️ TextField
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: widget.title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📤 زر ارسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  String newValue = controller.text;

                  /// هنا انت تربط فايربيس
                  print("القيمة الجديدة: $newValue");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم ارسال طلب التعديل")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("إرسال طلب التعديل"),
              ),
            )
          ],
        ),
      ),
    );
  }
}