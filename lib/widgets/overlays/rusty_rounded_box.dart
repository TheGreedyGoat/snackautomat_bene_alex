import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty.dart';

class RustyRoundedBox extends StatelessWidget {
  final Widget? child;
  final Color? color;
  const RustyRoundedBox({this.color, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Rusty(
      color: color,
      borderRadius: 25.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            opacity: 0.7,
            centerSlice: Rect.fromLTRB(
              20,
              20,
              481,
              481,
            ),
            image: AssetImage('assets/images/frame_shadow.9.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: child,
        ),
      ),
    );
  }
}
