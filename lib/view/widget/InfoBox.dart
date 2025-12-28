import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.all(2),child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 18,color: Colors.black),
      ),
    ),);
  }
}