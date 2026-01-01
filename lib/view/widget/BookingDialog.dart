import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ApartmentDetailsController.dart';
import 'TextFiled.dart';

class BookingDialog extends StatelessWidget {
  final ApartmentDetailsController controller;
  final int apartmentId;

  const BookingDialog({super.key, required this.controller, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.all(20),child: Center(
      child: Container(decoration: BoxDecoration(color: Colors.blueGrey[100],borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text("69".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blue)),
            CustomTextField(labelText: "70".tr, controller: controller.startDateController, readOnly: true, onTap: () async => await controller.pickStartDate(context)),
            CustomTextField(labelText: "تاريخ نهاية الحجز", controller: controller.endDateController, readOnly: true, onTap: () async => await controller.pickEndDate(context)),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => Get.back(), child:  Text("72".tr)),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: () async { Get.back(); await controller.bookApartment(apartmentId); }, child:  Text("73".tr)),
              ],
            ),
          ],
        ),
      ),
    )
      ,);}
}