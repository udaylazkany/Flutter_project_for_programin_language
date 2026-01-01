import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final dynamic prifixIcon;
  final bool readOnly;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  // padding اختياري
  final EdgeInsetsGeometry? padding;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.prifixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Material( // 👈 الحل الأساسي
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            textDirection: Directionality.of(context),
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: InputBorder.none,
              labelText: labelText,
              prefixIcon: prifixIcon,
            ),
          ),
        ),
      ),
    );
  }
}