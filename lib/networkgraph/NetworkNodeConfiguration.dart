import 'dart:ui';

import 'package:flutter/material.dart';

class NetworkNodeConfiguration {
  static bool showEasyMeshInformation = false;

  static Color backgroundColor = Color(0xFF0072B4);
  static Color foregroundColor = Color(0xFFFFFFFF);
  static Color secondaryBackgroundColor = Colors.white38;

  static TextStyle bodyTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w600,
      color: foregroundColor,
      fontSize: 16.0,
      height: 1.36
  );
  static TextStyle bodySecondaryTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w400,
      color: foregroundColor,
      fontSize: 16.0,
      height: 1.36
  );
  static TextStyle bodySmallTextStyle = bodySecondaryTextStyle.copyWith(
      fontSize: 11.5,
      color: backgroundColor
  );

  static double maxTextScaleFactor = 1.1;
}