/*MIT License

Copyright (c) 2020 Nabil Mosharraf

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

part of graphview;

class NetworkGraphConfiguration {
  static const ORIENTATION_TOP_BOTTOM = 1;
  static const ORIENTATION_BOTTOM_TOP = 2;
  static const ORIENTATION_LEFT_RIGHT = 3;
  static const ORIENTATION_RIGHT_LEFT = 4;
  static const DEFAULT_ORIENTATION = 1;
  static const int DEFAULT_ITERATIONS = 10;

  static const int X_SEPARATION = 100;
  static const int Y_SEPARATION = 100;

  static double heightOffset = 72.0;
  static double widthOffset = 32.0;

  int levelSeparation = Y_SEPARATION;
  int nodeSeparation = X_SEPARATION;
  int orientation = DEFAULT_ORIENTATION;
  int iterations = DEFAULT_ITERATIONS;
  BendPointShape bendPointShape = SharpBendPointShape();
  CoordinateAssignment coordinateAssignment = CoordinateAssignment.Average;

  bool addTriangleToEdge = false;

  static Color backgroundColor = Color(0xFF0072B4);
  static Color foregroundColor = Color(0xFFFFFFFF);

  int getLevelSeparation() {
    return levelSeparation;
  }

  int getNodeSeparation() {
    return nodeSeparation;
  }

  int getOrientation() {
    return orientation;
  }
}

enum NetworkGraphCoordinateAssignment {
  DownRight, // 0
  DownLeft, // 1
  UpRight, // 2
  UpLeft, // 3
  Average, // 4
}

abstract class NetworkGraphBendPointShape {}

class NetworkGraphSharpBendPointShape extends BendPointShape {}

class NetworkGraphMaxCurvedBendPointShape extends BendPointShape {}

class NetworkGraphCurvedBendPointShape extends BendPointShape {
  final double curveLength;

  NetworkGraphCurvedBendPointShape({
    required this.curveLength,
  });
}
