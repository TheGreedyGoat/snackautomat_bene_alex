import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';

/// Displays a box with a rusty texture, rounded corners and ahadows to make it seem like a 3D box
class RustyRoundedBox extends StatelessWidget {
  /// The content to show on the rusty box
  final Widget? child;

  final BoxDecoration? deocration;

  /// Displays a box with a rusty texture, rounded corners and ahadows to make it seem like a 3D box
  const RustyRoundedBox({
    this.deocration,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Rusty(
      decoration: deocration?.copyWith(borderRadius: BorderRadius.circular(25)),
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
          padding: const EdgeInsets.all(25),
          child: child,
        ),
      ),
    );
  }
}
