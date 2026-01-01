import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/components/crud.dart';
import '../../core/constant/linkapi.dart';
import '../view/screen/Home.dart';

class AddApartmentController extends GetxController {
  final Crud api = Crud();

  // Controllers
  final buildingNumber = TextEditingController();
  final floorNumber = TextEditingController();
  final apartmentNumber = TextEditingController();
  final streetName = TextEditingController();
  final city = TextEditingController();
  final price = TextEditingController();
  final space = TextEditingController();

  // Image
  Rx<File?> imageFile = Rx<File?>(null);

  // ============================
  // 🔥 تصفير الحقول عند فتح الصفحة
  // ============================
  @override
  void onInit() {
    super.onInit();
    clearFields();
  }

  void clearFields() {
    buildingNumber.clear();
    floorNumber.clear();
    apartmentNumber.clear();
    streetName.clear();
    city.clear();
    price.clear();
    space.clear();
    imageFile.value = null;
  }

  // ============================
  // Pick Image
  // ============================
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  // ============================
  // Submit Apartment
  // ============================
  Future<void> submit() async {
    if (imageFile.value == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    final storage = FlutterSecureStorage();
    String? userId = await storage.read(key: "userId");

    var response = await api.postRequestWithFile(
      linkAddApartment,
      {
        "buildingNumber": buildingNumber.text,
        "floorNumber": floorNumber.text,
        "apartmentNumber": apartmentNumber.text,
        "streetName": streetName.text,
        "city": city.text,
        "price": price.text,
        "space": space.text,
        "statusApartments": "vacant",
        "owner_Id": userId ?? "",
      },
      imageFile.value!.path,
    );

    if (response["status"] == 201) {
      Get.snackbar("Success", "Apartment added successfully");

      // 🔥 تصفير الحقول بعد الإرسال
      clearFields();

      await Future.delayed(Duration(seconds: 1));
      Get.offAll(Home());
    } else {
      Get.snackbar("Error", "Failed to add apartment");
    }
  }
}