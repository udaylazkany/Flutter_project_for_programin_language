import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ApartmentDetailsController.dart';
import 'TextFiled.dart';

class UpdateBookingDialog extends StatelessWidget {
  final ApartmentDetailsController controller;
  final int apartmentId;

  const UpdateBookingDialog({super.key, required this.controller, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.all(20),child: Center(
      child: Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.blueGrey[100]),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text("77".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            CustomTextField(labelText: "70".tr, controller: controller.startDateController, readOnly: true, onTap: () async => await controller.pickStartDate(context)),
            CustomTextField(labelText: "71".tr, controller: controller.endDateController, readOnly: true, onTap: () async => await controller.pickEndDate(context)),
            Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => Get.back(), child:  Text("72".tr)),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () async { Get.back(); await controller.updateBooking(apartmentId); }, child:  Text("73".tr)),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}