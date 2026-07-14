import 'package:flutter/material.dart';

class GlassPane extends StatelessWidget {
  const GlassPane({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.02),
                  Colors.white.withValues(alpha: 0.13),
                  Colors.white.withValues(alpha: 0.025),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.18, 0.24, 0.31, 1.0],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.025),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.12, 0.38],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.85, -0.9),
                radius: 1.1,
                colors: [
                  Colors.white.withValues(alpha: 0.07),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 1.5,
              ),
            ),
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/dust.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
