import 'package:flutter/material.dart';

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
    this.hasError = false,
    super.key,
  });

  /// The text's content
  final String data;

  /// The fontSize to display the text in (default: 20p)
  final double fontSize;

  /// if set to true, text will be displayed red, green else
  final bool hasError;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: hasError ? Colors.red : Colors.green,
        fontFamily: 'FixedSys',
        fontSize: fontSize,
      ),
      overflow: TextOverflow.clip,
      softWrap: false,
      maxLines: 1,
    );
  }
}
