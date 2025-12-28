import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/InfoBox.dart';
import 'package:flutter_application_2/view/widget/button.dart';
import 'package:get/get.dart';

class ApartmentDetails extends StatelessWidget {
  final String image;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String price;
  final String space;
  final String status;


  const ApartmentDetails({
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
    return Scaffold(
      appBar: AppBar(title: Text("15".tr)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),


            const SizedBox(height: 20),
            Row(children: [
              InfoBox(label: "المدينة ", value: city),
              InfoBox(label: "الشارع", value: streetName),
              InfoBox(label: "رقم البناء", value: buildingNumber),],),
            Row(children: [    InfoBox(label: "الطابق", value: floorNumber),
            InfoBox(label: "رقم الشقة", value: apartmentNumber),
            InfoBox(label: "السعر", value: price),
             ],),
            Row(children: [InfoBox(label: "المساحة", value: space),
              InfoBox(label: "الحالة", value: status),
            ],),button(hinttext: "إستئجار", onPressed: (){})
          ]
        ),
      ),
    );
  }
}