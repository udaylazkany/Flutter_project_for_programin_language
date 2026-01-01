import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ApartmentDetailsController.dart';
import '../widget/InfoBox.dart';
import '../widget/button.dart';
import '../widget/BookingActions.dart';
import 'CommentsPage.dart';

class BookedApartmentDetails extends StatelessWidget {
  final String image;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String price;
  final String space;
  final int apartmentId;

  // 🔹 الإضافات
  final String statusApartments;
  final String ownerName;     // اسم المالك
  final String locationName;  // اسم الموقع
  final String createdAt;
  final String updatedAt;

  const BookedApartmentDetails({
    super.key,
    required this.apartmentId,
    required this.image,
    required this.city,
    required this.streetName,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.price,
    required this.space,
    required this.statusApartments,
    required this.ownerName,
    required this.locationName,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApartmentDetailsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadApartmentStatus(apartmentId);
    });

    return Scaffold(
      appBar: AppBar(title:  Text("15".tr)),
      body: Column(
        children: [
          // 🔹 الصورة
          Image.network(
            image,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          BookingActions(controller: controller, apartmentId: apartmentId),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: button(
              hinttext: "38".tr,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentsPage(apartmentId: apartmentId),
                  ),
                );
              },
            ),
          ),


          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  InfoBox(label: "29".tr, value: city),
                  InfoBox(label: "30".tr, value: streetName),
                  InfoBox(label: "39".tr, value: buildingNumber),
                  InfoBox(label: "40".tr, value: floorNumber),
                  InfoBox(label: "41".tr, value: apartmentNumber),
                  InfoBox(label: "31".tr, value: price),
                  InfoBox(label: "32".tr, value: space),
                  InfoBox(label: "60".tr, value: ownerName),
                  InfoBox(label: "61".tr, value: locationName),


                  // 🔥 الحالة
                  Obx(() {
                    final status = controller.status.value.isNotEmpty
                        ? controller.status.value
                        : statusApartments;

                    return InfoBox(
                      label: "42".tr,
                      value: status == "vacant"
                          ? "43".tr
                          : status == "rented"
                          ? "44".tr
                          : "45".tr,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}