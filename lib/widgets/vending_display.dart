import 'package:flutter/material.dart';

import 'glass_pane.dart';

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
        border: Border.all(
          color: Colors.black,
          width: 14,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          const GlassPane(),
        ],
      ),
    );
  }
}
