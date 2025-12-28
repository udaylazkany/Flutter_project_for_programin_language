import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/ApartmentDetails.dart';

class CountainerviewApartment extends StatelessWidget {
  final String image;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String price;
  final String space;
  final String status;


  const CountainerviewApartment({
    super.key,
    required this.image,
    required this.city,
    required this.streetName,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.price,
    required this.space,
    required this.status,

  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: screenHeight * 0.35,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApartmentDetails(
                  image: image,
                  city: city,
                  streetName: streetName,
                  buildingNumber: buildingNumber,
                  floorNumber: floorNumber,
                  apartmentNumber: apartmentNumber,
                  price: price,
                  space: space,
                  status: status,

                ),
              ),
            );
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
    );
  }
}