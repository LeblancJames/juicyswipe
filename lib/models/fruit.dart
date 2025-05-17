import 'package:flutter/material.dart';

class FallingFruit {
  final String type;
  final String color;
  double xPosition; // from -1.0 (left) to 1.0 (right)
  double yPosition; // from 0.0 (top) to 1.0 (bottom)
  final Key key;
  bool isCaught = false;
  bool isMissed = false;
  FallingFruit({
    required this.type,
    required this.color,
    required this.xPosition,
    required this.yPosition,
  }) : key = UniqueKey();
}
