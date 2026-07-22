import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/glass_pane.dart';

/// Creates a low tech- style LCD display
///
/// The screen's content. Meant to be used with lcd- and layout widgets (such as Column/ Row etc.)
class LcdDisplay extends StatelessWidget {
  /// Creates a low tech- style LCD display
  ///
  /// The screen's content. Meant to be used with lcd- and layout widgets (such as Column/ Row etc.)
  const LcdDisplay({
    required this.height,
    required this.child,
    this.width,
    super.key,
  });

  /// The screen's content
  final Widget child;

  /// the screens's width
  final double? width;

  /// the screens's height
  final double height;
  @override
  Widget build(BuildContext context) {
    return _screen(
      child,
    );
  }

  Widget _screen(Widget content) => Card(
    color: Colors.black,
    child: SizedBox(
      height: height,
      width: width,
      child: GlassPane(
        borderRadius: 10,
        child: content,
      ),
    ),
  );
}
