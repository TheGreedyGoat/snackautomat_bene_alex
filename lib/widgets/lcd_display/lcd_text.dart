import 'package:flutter/material.dart';

class LcdText extends StatelessWidget {
  const LcdText(this.data, {this.fontSize, this.hasError = false, super.key});
  final String data;
  final double? fontSize;
  final bool hasError;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: hasError ? Colors.red : Colors.green,
        fontFamily: 'FixedSys',
        fontSize: fontSize ?? 20,
      ),
      overflow: TextOverflow.clip,
      softWrap: false,
      maxLines: 1,
    );
    ;
  }

  Text _text(String data, [double? fontSize, bool hasError = false]) => Text(
    data,
    style: TextStyle(
      color: hasError ? Colors.red : Colors.green,
      fontFamily: 'FixedSys',
      fontSize: fontSize ?? 20,
    ),
    overflow: TextOverflow.clip,
    softWrap: false,
    maxLines: 1,
  );
}
