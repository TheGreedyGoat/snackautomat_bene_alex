import 'package:flutter/material.dart';

/// A horizontal line going across the whole available lcd-screen space
class LcdSeparationLine extends StatelessWidget {
  /// A horizontal line going across the whole available lcd-screen space
  const LcdSeparationLine({this.hasError = false, super.key});

  /// if hasError is true, the line color will be set to red, green else
  final bool hasError;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    child: Container(
      color: hasError ? Colors.red : Colors.green,
    ),
  );
}
