import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final ImagePicker picker = ImagePicker();

  // الحقول
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthday = TextEditingController();

  // الصور
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> cardImage = Rx<XFile?>(null);

  RxBool profileAdded = false.obs;
  RxBool cardAdded = false.obs;

  // اختيار صورة شخصية
  Future<void> pickProfile() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      profileImage.value = img;
      profileAdded.value = true;
    }
  }

  // اختيار صورة بطاقة
  Future<void> pickCard() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      cardImage.value = img;
      cardAdded.value = true;
    }
  }

  // اختيار تاريخ الميلاد
  Future<void> pickBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      birthday.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }
}
