import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/HomeController.dart';
import '../../controller/SearchController1.dart';
import 'CountainerviewApartment.dart';

class SearchResultsGrid extends StatelessWidget {
  final SearchController1 searchController;
  final HomeController controller;

  const SearchResultsGrid({
    required this.searchController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (searchController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.noResults.value) {
        return  Center(
          child: Text(
            "36".tr,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      if (searchController.results.isEmpty) {
        return  Center(
          child: Text(
            "37".tr,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
        ),
        itemCount: searchController.results.length,
        itemBuilder: (context, index) {
          final item = searchController.results[index];
          final address = item["apartment__address"] ?? {};

          return CountainerviewApartment(
            apartmentId: item["id"],
            city: address["city"] ?? "",
            image: controller.getImageUrl(item["image"]),
            streetName: address["streetName"] ?? "",
            buildingNumber: address["buildingNumber"] ?? "",
            floorNumber: address["floorNumber"] ?? "",
            apartmentNumber: address["apartmentNumber"] ?? "",
            price: item["price"] ?? "",
            space: item["space"] ?? "",
            tenantId: controller.userId ?? "0",
            statusApartments: item["statusApartments"] ?? "",
            ownerId: item["owner_Id"].toString(),
            adressId: item["adress_Id"].toString(),
            createdAt: controller.formatDate(item["created_at"]),
            updatedAt: controller.formatDate(item["updated_at"]),
          );
        },
      );
    });
  }
}