import 'package:flutter/material.dart';

BoxDecoration _getRustyDecoration(Color? color, [double? borderRadius]) =>
    BoxDecoration(
      color: color,
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius)
          : null,
      image: DecorationImage(
        repeat: ImageRepeat.repeat,
        fit: BoxFit.contain,
        scale: 0.5,
        image: AssetImage('assets/images/decoration/rusty_overlay.png'),
      ),
    );

class Rusty extends StatelessWidget {
  final Color? color;
  final Widget? child;
  final double? borderRadius;
  const Rusty({this.color, this.child, this.borderRadius, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _getRustyDecoration(color, borderRadius),
      child: child,
    );
  }
}
