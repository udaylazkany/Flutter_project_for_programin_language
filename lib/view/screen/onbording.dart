import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login.dart';

class OnBording extends StatefulWidget {
  const OnBording({super.key});

  @override
  State<OnBording> createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 30), () {
      Get.off(() =>  Login());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/Desig.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              "1".tr,
              style: const TextStyle(fontSize: 60, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}