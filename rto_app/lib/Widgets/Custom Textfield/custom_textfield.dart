import 'package:flutter/material.dart';
import '../App Colors/AppColors.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final Widget? preFixIcon;
  final Widget? sufFixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? errormsg;
  final bool visibility, valid;

  const CustomTextfield({
    required this.controller,
    required this.keyboardType,
    this.errormsg,
    this.hintText,
    this.preFixIcon,
    this.sufFixIcon,
    this.onTap,
    this.readOnly = false,
    this.visibility = false,
    this.valid = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: preFixIcon,
          suffixIcon: sufFixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
