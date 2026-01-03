import 'package:flutter/material.dart';
import 'dart:ui';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final double blurStrength;
  final Color backgroundColor;
  final Color foregroundColor;

  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.blurStrength = 10.0,
    this.backgroundColor = const Color(0x33000000), // 20% opacity
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurStrength,
          sigmaY: blurStrength,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: Text(title),
            leading: leading,
            actions: actions,
            backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
