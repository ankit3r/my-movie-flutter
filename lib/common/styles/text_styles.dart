import 'package:mymovie/utils/sizes.dart';
import 'package:mymovie/utils/colors.dart';
import 'package:flutter/material.dart';

// -------------------- STATIC TEXT STYLES --------------------

// small text style
const TextStyle smallText = TextStyle(
  fontSize: smallTextSize,
  fontWeight: FontWeight.normal,
);

// small bold text style
const TextStyle smallBoldText = TextStyle(
  fontSize: smallTextSize,
  fontWeight: FontWeight.bold,
);

// medium text style
const TextStyle mediumText = TextStyle(
  fontSize: mediumTextSize,
  fontWeight: FontWeight.normal,
);

// medium bold text style
const TextStyle mediumBoldText = TextStyle(
  fontSize: mediumTextSize,
  fontWeight: FontWeight.bold,
);

// large text style
const TextStyle largeText = TextStyle(
  fontSize: largeTextSize,
  fontWeight: FontWeight.normal,
);

// large bold text style
const TextStyle largeBoldText = TextStyle(
  fontSize: largeTextSize,
  fontWeight: FontWeight.bold,
);

// xlarge text style
const TextStyle xLargeText = TextStyle(
  fontSize: xLargeTextSize,
  fontWeight: FontWeight.normal,
);

// xlarge bold text style
const TextStyle xLargeBoldText = TextStyle(
  fontSize: xLargeTextSize,
  fontWeight: FontWeight.bold,
);

// xxlarge text style
const TextStyle xxLargeText = TextStyle(
  fontSize: xxLargeTextSize,
  fontWeight: FontWeight.normal,
);

// xxlarge bold text style
const TextStyle xxLargeBoldText = TextStyle(
  fontSize: xxLargeTextSize,
  fontWeight: FontWeight.bold,
);

// heading bold
const TextStyle headingBold = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF6E0338),
);

// normal text
const TextStyle normalText = TextStyle(
  fontSize: mediumTextSize,
  fontWeight: FontWeight.normal,
);

// link text
const TextStyle linkText = TextStyle(
  fontSize: mediumTextSize,
  fontWeight: FontWeight.bold,
  color: Color(0xFF6E0338),
);

// secondary link text
const TextStyle secondaryLinkText = TextStyle(
  fontSize: mediumTextSize,
  color: Color(0xFF10298E),
);

// -------------------- DYNAMIC TEXT STYLES --------------------
// (Auto change based on Light / Dark Mode)

class AppTextStyles {
  AppTextStyles._();

  /// 🔹 First custom style:
  /// Light → darkRed, Dark → white
  static TextStyle primaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: mediumTextSize,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : darkRed,
    );
  }

  /// 🔹 Second custom style:
  /// Light → lightRed, Dark → white70
  static TextStyle secondaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: mediumTextSize,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : lightRed,
    );
  }
}
