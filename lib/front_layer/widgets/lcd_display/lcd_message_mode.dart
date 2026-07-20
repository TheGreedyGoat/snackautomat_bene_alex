import 'package:flutter/material.dart';

enum LcdMessageMode {
  normal(color: Colors.green),
  warning(color: Colors.yellow),
  error(color: Colors.red);

  final Color color;
  const LcdMessageMode({required this.color});
}
