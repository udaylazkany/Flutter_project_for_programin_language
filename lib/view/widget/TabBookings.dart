import 'package:flutter/material.dart';
import '../../../controller/HomeController.dart';
import '../../controller/CountainerviewApartmentController.dart';
import '../screen/CountainerviewBookedApartment.dart';
import 'package:get/get.dart';
class TabBookings extends StatelessWidget {
  final HomeController controller;
  final CountainerviewApartmentController apartmentController =
  Get.put(CountainerviewApartmentController());


  TabBookings({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.myBookingApartments.isEmpty) {
      return  Center(
        child: Text(
"74".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
      ),
      itemCount: controller.myBookingApartments.length,
      itemBuilder: (context, index) {
        final apt = controller.myBookingApartments[index];
        final address = controller.myBookingAddresses[index];

        return CountainerviewBookedApartment(
          apartmentId: apt["id"],
          city: address["city"] ?? "",
          image: controller.getImageUrl(apt["image"]),
          streetName: address["streetName"] ?? "",
          buildingNumber: address["buildingNumber"] ?? "",
          floorNumber: address["floorNumber"] ?? "",
          apartmentNumber: address["apartmentNumber"] ?? "",
          price: apt["price"] ?? "",
          space: apt["space"] ?? "",
          tenantId: controller.userId ?? "0",
          statusApartments: apt["statusApartments"] ?? "",
          ownerName:
          "${apt["clients"]["firstName"] ?? ""} ${apt["clients"]["lastName"] ?? ""}",
          locationName: address["city"] ?? "",
          createdAt: controller.formatDate(apt["created_at"]),
          updatedAt: controller.formatDate(apt["updated_at"]),
        );
      },
    );
  }
}