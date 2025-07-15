import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isDark;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? CupertinoColors.darkBackgroundGray : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        maxLines: 6,
        minLines: 6,
        padding: const EdgeInsets.all(18),
        style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black),
        decoration: null,
      ),
    );
  }
}
