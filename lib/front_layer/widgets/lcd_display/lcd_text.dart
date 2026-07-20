import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';

/// Meant for usage in LCD display widget.
///
/// Displays text in the style of an old lcd display.
class LcdText extends StatelessWidget {
  /// Meant for usage in LCD display widget.
  ///
  /// Displays text in the style of an old lcd display.
  ///
  ///  - String [data]: The text's content

  ///  - fontSize [fontSize]: The fontSize to display the text in (default: 20p)

  ///  - bool [hasError]: if set to true, text will be displayed red, green else
  const LcdText(
    this.data, {
    this.fontSize = 20,
    this.mode = LcdMessageMode.normal,
    super.key,
  });

  /// The text's content
  final String data;
  final LcdMessageMode mode;

  /// The fontSize to display the text in (default: 20p)
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: mode.color,
        fontFamily: 'FixedSys',
        fontSize: fontSize,
      ),
      overflow: TextOverflow.clip,
      softWrap: false,
      maxLines: 1,
    );
  }
}
