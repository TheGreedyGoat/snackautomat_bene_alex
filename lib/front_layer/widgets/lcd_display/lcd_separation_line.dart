import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';

/// A horizontal line going across the whole available lcd-screen space
class LcdSeparationLine extends StatelessWidget {
  /// A horizontal line going across the whole available lcd-screen space
  const LcdSeparationLine({this.mode = LcdMessageMode.normal, super.key});

  /// if hasError is true, the line color will be set to red, green else
  final LcdMessageMode mode;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    child: Container(
      color: mode.color,
    ),
  );
}
