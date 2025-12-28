import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/TextFiled.dart';
import 'package:flutter_application_2/view/widget/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/components/crud.dart';
import '../../core/constant/linkapi.dart';

class AddApartmentPage extends StatelessWidget {
  AddApartmentPage({super.key});

  final Crud api = Crud();

  // Controllers
  final buildingNumber = TextEditingController();
  final floorNumber = TextEditingController();
  final apartmentNumber = TextEditingController();
  final streetName = TextEditingController();
  final city = TextEditingController();
  final price = TextEditingController();
  final space = TextEditingController();
  final statusApartments = TextEditingController();


  // Image Notifier
  final ValueNotifier<File?> imageFile = ValueNotifier(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  Future<void> submit(BuildContext context) async {
    if (imageFile.value == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

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
          "owner_Id": ?userId,

      },
      imageFile.value!.path,
    );

    print("RESPONSE: $response");

    if (response["status"] == true) {
      Get.snackbar("Success", "Apartment added successfully");
      Navigator.pop(context);
    } else {
      Get.snackbar("Error", "Failed to add apartment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة شقة")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
        CustomTextField(hintText: "رقم البناء", controller: buildingNumber,obscureText: false,),
            CustomTextField(hintText: "رقم الطابق", controller: floorNumber,obscureText: false,),
            CustomTextField(hintText: "رقم الشقة", controller: apartmentNumber,obscureText: false,),
            CustomTextField(hintText: "اسم الشارع", controller: streetName,obscureText: false,),
            CustomTextField(hintText: "المدينة", controller: city,obscureText: false,),
            CustomTextField(hintText: "السعر", controller:price,obscureText: false, ),
            CustomTextField(hintText: "مساحة الشقة", controller: space,obscureText: false,),



            ValueListenableBuilder<File?>(
              valueListenable: imageFile,
              builder: (context, file, _) {
                return Column(
                  children: [
                    file == null
                        ? ElevatedButton(
                      onPressed: pickImage,
                      child: Icon(Icons.add_a_photo),
                    )
                        :ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        file,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                  ],
                );
              },
            ),

           button(hinttext: "send", onPressed:(){submit(context);} ),



          ],
        ),
      ),
    );
  }

 }