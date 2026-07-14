import 'package:flutter/material.dart';

BoxDecoration getRustyDecoration(Color? color) => BoxDecoration(
  color: color,
  image: DecorationImage(
    repeat: ImageRepeat.repeat,
    fit: BoxFit.contain,
    scale: 0.5,
    image: AssetImage('assets/images/decoration/rusty_overlay.png'),
  ),
);
