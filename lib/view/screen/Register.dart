import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/controller/RegisterController.dart';
import 'package:get/get.dart';

import '../../core/components/crud.dart';
import '../../core/constant/linkapi.dart';
import '../widget/TextFiled.dart';
import '../widget/button.dart';
import 'Home.dart';
import 'wait.dart';





// ======================================================
// ===================== Register UI ====================
// ======================================================

class Register extends StatelessWidget {

  final Crud _crud = Crud();
  final RegisterController controller = Get.put(RegisterController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  // =============== SIGN UP FUNCTION ====================
  Future<void> signUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (!controller.profileAdded.value || !controller.cardAdded.value) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("65".tr)),
      );
      return;
    }

    var response = await _crud.postRequestWithFiles(
      linkeregister,
      {
        "firstName": controller.firstName.text,
        "lastName": controller.lastName.text,
        "phoneNumber": controller.phoneNumber.text,
        "password": controller.password.text,
        "dob": controller.birthday.text,
      },
      {
        "personal_photo": controller.profileImage.value!.path,
        "personal_id_photo": controller.cardImage.value!.path,
      },
    );

    print("Response: $response");

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No response from server")),
      );
      return;
    }

    if (response["status"] == true || response["status"] == 201) {
      bool approved = response["data"]["is_approved"] == 1;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => approved ?  Home() : const Waiting(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"].toString())),
      );
    }
  }



  // ===================== UI ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          "7".tr,
                          style: const TextStyle(
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ================== الاسم الأول + الأخير ==================
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                padding: EdgeInsetsGeometry.symmetric(horizontal: 1),
                                labelText: "20".tr,
                                controller: controller.firstName,
                                validator: (v) =>
                                v!.isEmpty ? "66".tr : null,
                              ),
                            ),

                            Expanded(
                              child: CustomTextField(padding: EdgeInsetsGeometry.symmetric(horizontal: 1),
                                labelText: "21".tr,
                                controller: controller.lastName,
                                validator: (v) =>
                                v!.isEmpty ? "66".tr : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ================== رقم الهاتف ==================

                        CustomTextField(
                          labelText: "3".tr,
                          controller: controller.phoneNumber,
                          keyboardType: TextInputType.number,
                          prifixIcon: const Icon(Icons.phone),
inputFormatters: [  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(10),
],
                          validator: (v) => v!.length < 9 ? "67".tr : null,
                        )
                        ,const SizedBox(height: 10),

                        // ================== كلمة المرور ==================
                        CustomTextField(
                          labelText: "4".tr,
                          obscureText: true,
                          controller: controller.password,
                          validator: (v) =>
                          v!.length < 6 ? "68".tr : null,
                        ),

                        const SizedBox(height: 20),

                        // ================== أزرار الصور ==================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                                  () => ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.profileAdded.value
                                      ? Colors.green
                                      : Colors.grey[300],
                                ),
                                onPressed: controller.pickProfile,
                                icon: const Icon(Icons.add_a_photo),
                                label: Text("9".tr),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Obx(
                                  () => ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.cardAdded.value
                                      ? Colors.green
                                      : Colors.grey[300],
                                ),
                                onPressed: controller.pickCard,
                                icon: const Icon(Icons.credit_card),
                                label: Text("10".tr),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================== تاريخ الميلاد ==================
                        CustomTextField(labelText: "22".tr, controller: controller.birthday,obscureText: false,prifixIcon: Icon(Icons.date_range),
                          onTap: () => controller.pickBirthday(context), readOnly: true,
                        ),

                        const SizedBox(height: 20),

                        // ================== زر التسجيل ==================
                        button(
                          hinttext: "7".tr,
                          onPressed: () => signUp(context),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("8".tr),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("2".tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}