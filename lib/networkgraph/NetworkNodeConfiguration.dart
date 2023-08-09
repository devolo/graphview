/*MIT License

Copyright (c) 2020 Nabil Mosharraf

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

import 'dart:ui';

import 'package:flutter/material.dart';

class NetworkNodeConfiguration {
  static bool showEasyMeshInformation = false;

  static Color backgroundColor = Color(0xFF0072B4);
  static Color foregroundColor = Color(0xFFFFFFFF);
  static Color offlineForegroundColor = Colors.white38;

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
      fontSize: 14,
      color: backgroundColor
  );

  static double maxTextScaleFactor = 1.1;

  static double maxTextWidth = 84.0;
  static double circleSize = 96.0;
  static double iconSize = 24.0;
  static double internetIconSize = 48.0;
  static double speedIconSize = 12.0;
  static double textPadding = 8.0;

  static bool shouldShowClients = false;
}