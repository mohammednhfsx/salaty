import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salaty/controller/auth/resent_password_controller.dart';
import 'package:salaty/core/theme/colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResentPasswordControllerImp controllerImp = Get.put(
      ResentPasswordControllerImp(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("نسيت كلمة المرور")),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(30),
          child: Form(
            key: controllerImp.formKey,
            child: Column(
             
              children: [
                const Text(
                  "أدخل إيميلك وراح نرسل لك رابط إعادة التعيين",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: controllerImp.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "أدخل الإيميل";
                    if (!GetUtils.isEmail(val)) return "إيميل غير صحيح";
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: splash_screenColors,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (controllerImp.formKey.currentState!.validate()) {
                          controllerImp.resetPassword();
                        }
                      },
                      child: Text(
                        "إرسال",

                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
