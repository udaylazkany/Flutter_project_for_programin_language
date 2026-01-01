import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ApartmentDetailsController.dart';

import 'BookingDialog.dart';
import 'UpdateBookingDialog.dart';
import 'button.dart';
class BookingActions extends StatelessWidget {
  final ApartmentDetailsController controller;
  final int apartmentId;

  const BookingActions({
    super.key,
    required this.controller,
    required this.apartmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contractStatus = controller.contractStatus.value;
      final tenantId = controller.tenantId.value;
      final currentTenantId = controller.currentTenantId.value;
      final owner = controller.ownerId.value;

      // ---------------------------------------------------------
      // 🔹 1) المالك
      // ---------------------------------------------------------
      if (owner == currentTenantId) {
        switch (contractStatus) {
          case "active":
            return button(
              hinttext: "46".tr,
              onPressed: () async => await controller.cancelBooking(apartmentId),
            );

          case "waiting cancel":
            return Row(
              children: [
                Expanded(
                  child: button(
                    hinttext: "47".tr,
                    onPressed: () async => await controller.approveCancel(
                      controller.contractId.value,
                      apartmentId,
                    ),
                  ),
                ),
                Expanded(
                  child: button(
                    hinttext: " 48".tr,
                    onPressed:() async => await controller.rejectCancel(
                      controller.contractId.value,
                      apartmentId,
                    ),
                  ),
                ),
              ],
            );
          case "waiting update":
            return Row(
              children: [
                Expanded(
                  child: button(
                    hinttext: "49".tr,
                    onPressed: () async => await controller.approveUpdate(
                      controller.contractId.value,
                      apartmentId,
                    ),
                  ),
                ),
                Expanded(
                  child: button(
                    hinttext: "50".tr,
                    onPressed:  () async => await controller.rejectUpdate(
                      controller.contractId.value,
                      apartmentId,
                    ),
                  ),
                ),
              ],
            );













     //////////////////////////////
     ///////////////////////////
     /////////////////////
     /////////////


          case "waiting approve":
            return button(
              hinttext: "51".tr,
              onPressed: () async =>
                  await controller.acceptBooking(controller.contractId.value),
            );

          case "cancelled":
          case "none":
            return Row(
              children: [
                Expanded(
                  child: button(
                    hinttext: "52".tr,
                    onPressed: () async =>
                        await controller.deleteApartmentAndRefresh(apartmentId),
                  ),
                ),
                Expanded(
                  child: button(
                    hinttext: "53".tr,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => UpdateBookingDialog(
                          controller: controller,
                          apartmentId: apartmentId,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );

          default:
            return const SizedBox.shrink();
        }
      }

      // ---------------------------------------------------------
      // 🔹 2) المستأجر
      // ---------------------------------------------------------
      if (tenantId == currentTenantId) {
        if (contractStatus == "active") {
          return Row(
            children: [
              Expanded(
                child: button(
                  hinttext: "46".tr,
                  onPressed: () async => await controller.cancelBooking(apartmentId),
                ),
              ),
              Expanded(
                child: button(
                  hinttext: "54".tr,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => UpdateBookingDialog(
                        controller: controller,
                        apartmentId: apartmentId,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (contractStatus == "waiting cancel" ||
            contractStatus == "waiting update") {
          return button(hinttext: "55".tr, onPressed: () {});
        }

        if (contractStatus == "waiting approve") {
          return button(hinttext: "55".tr, onPressed: () {});
        }

        if (contractStatus == "cancelled" || contractStatus == "none") {
          return button(
            hinttext: "56".tr,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BookingDialog(
                  controller: controller,
                  apartmentId: apartmentId,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      }

      // ---------------------------------------------------------
      // 🔹 3) مستخدم آخر (لا هو مالك ولا مستأجر)
      // ---------------------------------------------------------
      if (contractStatus == "active") {
        return button(hinttext: "57".tr, onPressed: () {});
      }

      if (contractStatus == "cancelled" ||
          contractStatus == "none" ||
          contractStatus == "waiting approve") {
        return button(
          hinttext: "56".tr,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BookingDialog(
                controller: controller,
                apartmentId: apartmentId,
              ),
            );
          },
        );
      }

      return button(hinttext: "57".tr, onPressed: () {});
    });
  }
}