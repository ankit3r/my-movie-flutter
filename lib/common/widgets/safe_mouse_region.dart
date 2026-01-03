// lib/common/widgets/safe_mouse_region.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class SafeMouseRegion extends StatelessWidget {
  final Widget child;
  final MouseCursor cursor;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
  final PointerHoverEventListener? onHover;

  const SafeMouseRegion({
    super.key,
    required this.child,
    this.cursor = SystemMouseCursors.click,
    this.onEnter,
    this.onExit,
    this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    // Only use MouseRegion on web
    if (!kIsWeb) {
      return child;
    }

    return MouseRegion(
      cursor: cursor,
      onEnter: onEnter,
      onExit: onExit,
      onHover: onHover,
      child: child,
    );
  }
}
