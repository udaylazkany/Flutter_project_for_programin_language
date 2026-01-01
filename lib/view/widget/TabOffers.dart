import 'package:flutter/material.dart';
import '../../../controller/HomeController.dart';
import 'CountainerviewApartment.dart';
import 'package:get/get.dart';


class TabOffers extends StatelessWidget {
  final HomeController controller;

  const TabOffers({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.apartments.isEmpty) {
      return  Center(
        child: Text(
          "76".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }


    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
      ),
      itemCount: controller.apartments.length,
      itemBuilder: (context, index) {
        final apt = controller.apartments[index];
        final address = controller.getAddressForApartment(apt);

        return CountainerviewApartment(
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
          ownerId: apt["owner_Id"].toString(),
          adressId: apt["adress_Id"].toString(),
          createdAt: controller.formatDate(apt["created_at"]),
          updatedAt: controller.formatDate(apt["updated_at"]),
        );
      },
    );
  }
}