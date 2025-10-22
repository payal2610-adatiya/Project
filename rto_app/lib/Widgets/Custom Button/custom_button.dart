import 'package:flutter/material.dart';
import '../App Colors/AppColors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const CustomButton({
    required this.onPressed,
    required this.child,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.backgroundColor = AppColors.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.3),
      ),
      child: child,
    );
  }
}
