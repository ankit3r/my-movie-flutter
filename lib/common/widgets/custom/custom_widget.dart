

import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

mixin CustomWidget {
  /// Custom TextField
  Widget appTextField({
    required String label,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: borderRed),
        ),
      ),
    );
  }

  /// Custom Button
  Widget appButton({
    required String text,
    required VoidCallback onPressed,
    Color background = lightRed,
    Color foreground = Colors.white,
    double borderRadius = 30,
    double verticalPadding = 14,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
        ),
        child: Text(text),
      ),
    );
  }
}
