import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_text.dart';

class NukaColaAscii extends StatelessWidget {
  const NukaColaAscii({this.fontSize = 15, super.key});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        LcdText(
          '  __',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  |\'\'|',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  /  \\',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  /Nuka\\',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  | Cola |',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  /|  ||  |\\',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
        LcdText(
          '  |_|__||__|_|',
          fontSize: fontSize,
          mode: LcdMessageMode.error,
        ),
      ],
    );
  }
}
