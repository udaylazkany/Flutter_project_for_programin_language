import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ApartmentDetailsController.dart';
import '../../controller/MessageController.dart';
import 'CommentsPage.dart';
import '../widget/InfoBox.dart';
import '../widget/button.dart';
import '../widget/BookingActions.dart';
import 'MessagesPage.dart';

class ApartmentDetails extends StatelessWidget {
  final String image;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String price;
  final String space;
  final String ownerId;
  final int apartmentId;

  const ApartmentDetails({
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
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApartmentDetailsController());

    controller.ownerId.value = int.tryParse(ownerId) ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadApartmentStatus(apartmentId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("15".tr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () async {
                final messageController = Get.put(MessageController());

                // جلب المحادثات الخاصة بالمستخدم
                await messageController.getUserConversations();

                // البحث عن محادثة موجودة مسبقًا بين المستخدم والمالك
                int owner = int.parse(ownerId);
                int? existingConversationId;

                for (var conv in messageController.conversations) {
                  if (conv["owner_id"] == owner || conv["tenant_id"] == owner) {
                    existingConversationId = conv["id"];
                    break;
                  }
                }

                // فتح صفحة الرسائل
                Get.to(() => MessagesPage(
                  conversationId: existingConversationId,
                  ownerId: owner,
                ));
              },
            ),
          )
        ],
      ),
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
            const SizedBox(height: 20),
            Wrap(
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
                Obx(() {
                  final status = controller.status.value;
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
            const SizedBox(height: 20),
            BookingActions(controller: controller, apartmentId: apartmentId),
          ],
        ),
      ),
    );
  }
}
