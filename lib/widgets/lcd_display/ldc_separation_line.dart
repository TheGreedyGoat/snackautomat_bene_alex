import 'package:flutter/material.dart';

class LcdSeparationLine extends StatelessWidget {
  const LcdSeparationLine({this.hasError = false, super.key});
  final bool hasError;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    child: Container(
      color: hasError ? Colors.red : Colors.green,
    ),
  );
}
