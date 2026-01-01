import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';
import '../view/screen/Home.dart';
import '../view/screen/wait.dart';

class LoginController extends GetxController {
  final Crud crud = Crud();
  final storage = const FlutterSecureStorage();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = "".obs;

  Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      var response = await crud.postRequestNoToken(
        linkelogin,
        {
          "phoneNumber": phoneNumber.text,
          "password": password.text,
        },
      );

      if (response == null) {
        errorMessage.value = "26".tr;
        Get.snackbar("24".tr, errorMessage.value);
        return;
      }

      print("Response: $response");

      if (response["status"] == true || response["status"] == 201) {
        // حفظ التوكين
        String token = response["token"];
        await saveToken(token);

        // حفظ الدور
        await storage.write(
          key: "role",
          value: response["data"]["role"],
        );

        // 🔥 حفظ userId بشكل واضح وصحيح
        await storage.write(
          key: "userId",
          value: response["data"]["id"].toString(),
        );
        print("🔥 USER ID SAVED IN STORAGE: ${await storage.read(key: "userId")}");
        print("Saved Token: ${await storage.read(key: "token")}");
        print("Saved User ID: ${await storage.read(key: "userId")}");

        // التوجيه حسب حالة الموافقة
        if (response["data"]["is_approved"] == 1) {
          Get.offAll(() => Home());
        } else {
          Get.offAll(() => const Waiting());
        }
      } else {
        errorMessage.value = response["message"] ?? "25".tr;
        Get.snackbar("24".tr, errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "23".tr;
      Get.snackbar("24".tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneNumber.dispose();
    password.dispose();
    super.onClose();
  }
}