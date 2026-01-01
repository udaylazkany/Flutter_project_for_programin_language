import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/widget/TabBookings.dart';
import 'package:flutter_application_2/view/widget/TabMyApartments.dart';
import 'package:flutter_application_2/view/widget/TabOffers.dart';
import '../../../controller/HomeController.dart';

class HomeTabs extends StatelessWidget {
  final HomeController controller;

  const HomeTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: controller.isOwner
          ? [
        TabOffers(controller: controller),
        TabBookings(controller: controller),
        TabMyApartments(controller: controller),
      ]
          : [
        TabOffers(controller: controller),
        TabBookings(controller: controller),
      ],
    );
  }
}