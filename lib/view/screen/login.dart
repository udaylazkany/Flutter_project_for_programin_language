import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/LoginController.dart';
import '../widget/TextFiled.dart';
import '../widget/button.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/Images/logo.png'),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "2".tr,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                ),
                              ),

                              // ============================
                              // 🔥 Phone Number
                              // ============================
                              CustomTextField(keyboardType: TextInputType.number,
                                key: const ValueKey("phoneNumber"),
                                labelText: "3".tr,
                                obscureText: false,
                                controller: controller.phoneNumber,
                                validator: (v) =>
                                v!.length != 10 ? "27".tr : null,
                                prifixIcon: const Icon(Icons.phone),
                              ),

                              // ============================
                              // 🔥 Password
                              // ============================
                              CustomTextField(
                                key: const ValueKey("password"),
                                prifixIcon: const Icon(Icons.lock),
                                labelText: "4".tr,
                                obscureText: true,
                                controller: controller.password,
                              ),

                              // ============================
                              // 🔥 Login Button
                              // ============================
                              button(
                                hinttext: "2".tr,
                                onPressed: () async {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    await controller.signIn();
                                  }
                                },
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("6".tr,
                                      style:
                                      const TextStyle(color: Colors.black)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                    child: Text("7".tr),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ============================
            // 🔥 Loading Overlay
            // ============================
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}