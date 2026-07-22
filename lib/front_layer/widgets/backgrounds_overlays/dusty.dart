import 'package:flutter/material.dart';

class Dusty extends StatelessWidget {
  /// optional content
  final Widget? child;
  final BoxDecoration? decoration;

  /// A decorated box resembling a rusty painted metal texture
  const Dusty({
    this.child,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dustyTexture = DecorationImage(
      repeat: ImageRepeat.repeat,
      fit: BoxFit.cover,
      alignment: AlignmentGeometry.centerLeft,
      scale: 0.5,
      image: AssetImage('assets/images/decoration/dust.png'),
    );

    return DecoratedBox(
      decoration:
          decoration?.copyWith(image: dustyTexture) ??
          BoxDecoration(
            image: dustyTexture,
          ),

      child: child,
    );
  }
}
