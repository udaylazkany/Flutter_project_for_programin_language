
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_application_2/view/widget/TextFiled.dart';
import 'package:flutter_application_2/view/widget/button.dart';

import '../../controller/AddApartmentController.dart';

class AddApartmentPage extends StatelessWidget {
  AddApartmentPage({super.key});

  final AddApartmentController controller =
  Get.put(AddApartmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("16".tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(keyboardType: TextInputType.number,
                labelText: "39".tr,
                controller: controller.buildingNumber,
                obscureText: false),
            CustomTextField(keyboardType: TextInputType.number,
                labelText: "40".tr,
                controller: controller.floorNumber,
                obscureText: false),
            CustomTextField(keyboardType: TextInputType.number,
                labelText: "41".tr,
                controller: controller.apartmentNumber,
                obscureText: false),
            CustomTextField(
                labelText: "30".tr,
                controller: controller.streetName,
                obscureText: false),
            CustomTextField(
                labelText: "29".tr,
                controller: controller.city,
                obscureText: false),
            CustomTextField(keyboardType: TextInputType.number,
                labelText: "31".tr,
                controller: controller.price,
                obscureText: false),
            CustomTextField(keyboardType: TextInputType.number,
                labelText: "32".tr,
                controller: controller.space,
                obscureText: false),

            const SizedBox(height: 20),

            Obx(() {
              final file = controller.imageFile.value;
              return file == null
                  ? ElevatedButton(
                onPressed: controller.pickImage,
                child: Icon(Icons.add_a_photo),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  file,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              );
            }),

            const SizedBox(height: 20),

            button(
              hinttext: "59".tr,
              onPressed: controller.submit,
            ),
          ],
        ),
      ),
    );
  }
}