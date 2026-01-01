import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/CountainerviewApartmentController.dart';
import 'BookedApartmentDetails.dart';

class CountainerviewBookedApartment extends StatelessWidget {
  final String image;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String price;
  final String space;
  final int apartmentId;
  final String tenantId;

  // 🔹 الإضافات الجديدة
  final String statusApartments;
  final String ownerName;
  final String locationName;
  final String createdAt;
  final String updatedAt;

   CountainerviewBookedApartment({
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
    required this.tenantId,
    required this.statusApartments,
    required this.ownerName,
    required this.locationName,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CountainerviewApartmentController>();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadApartmentStatus(apartmentId);
    });

    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: screenHeight * 0.35,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookedApartmentDetails(
                      apartmentId: apartmentId,
                      image: image,
                      city: city,
                      streetName: streetName,
                      buildingNumber: buildingNumber,
                      floorNumber: floorNumber,
                      apartmentNumber: apartmentNumber,
                      price: price,
                      space: space,
                      statusApartments: statusApartments,
                      ownerName: ownerName,
                      locationName: locationName,
                      createdAt: createdAt,
                      updatedAt: updatedAt,
                    ),
                  ),
                ).then((_) {

                  controller.loadApartmentStatus(apartmentId);
                });

              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.amberAccent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),


          Obx(() {
            final status =
                controller.apartmentsStatus[apartmentId] ?? "loading";

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                status == "vacant"
                    ? "43".tr
                    : status == "rented"
                    ? "44".tr
                    : "45".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: status == "vacant"
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
