import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  CustomAppbar({
    required this.title,
    required this.centerTitle,
    super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Text(title),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

