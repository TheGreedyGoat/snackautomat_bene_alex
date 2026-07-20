import 'package:flutter/material.dart';

import 'backgrounds_overlays/glass_pane.dart';

class VendingDisplay extends StatelessWidget {
  final Widget child;

  const VendingDisplay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GlassPane(
        child: child,
      ),
      // Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     child,
      //   ],
      // ),
    );
  }
}
