import 'package:flutter/material.dart';

/// A decorated box resembling a rusty painted metal texture
class Rusty extends StatelessWidget {
  /// The color to layer the rust on
  final Color? color;

  /// optional content
  final Widget? child;

  ///
  final double? borderRadius;

  ///
  final BoxShape boxShape;

  /// A decorated box resembling a rusty painted metal texture
  const Rusty({
    this.color,
    this.child,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
        shape: boxShape,
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: AlignmentGeometry.centerLeft,
          scale: 0.5,
          image: AssetImage('assets/images/decoration/rusty_overlay.png'),
        ),
      ),

      child: child,
    );
  }
}
