import 'package:flutter/material.dart';

enum RustLevel {
  light(texture: 'assets/images/decoration/rusty_light.png'),
  medium(texture: 'assets/images/decoration/rusty_overlay.png');

  final String texture;
  const RustLevel({required this.texture});
}

/// A decorated box resembling a rusty painted metal texture
class Rusty extends StatelessWidget {
  final BoxDecoration? decoration;

  /// optional content
  final Widget? child;

  final RustLevel rustLevel;

  /// A decorated box resembling a rusty painted metal texture
  const Rusty({
    this.child,
    this.decoration,
    this.rustLevel = RustLevel.medium,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rustyTexture = DecorationImage(
      repeat: ImageRepeat.repeat,
      fit: BoxFit.cover,
      alignment: AlignmentGeometry.centerLeft,
      scale: 0.5,
      image: AssetImage(rustLevel.texture),
    );

    return DecoratedBox(
      decoration:
          decoration?.copyWith(image: rustyTexture) ??
          BoxDecoration(image: rustyTexture),

      child: child,
    );
  }
}
