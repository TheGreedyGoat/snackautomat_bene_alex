import 'package:flutter/material.dart';

/// Metallschranke mit fester Balkenhöhe (Breite vom Parent).
/// [open] 0 = zu, 1 = offen (hochgeklappt).
class MetalGate extends StatelessWidget {
  final double open;

  const MetalGate({super.key, required this.open});

  static const double barHeight = 16;
  static const double hingeWidth = 18;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          width: width,
          height: barHeight * 2.2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateZ(-1.35 * open),
              child: Container(
                width: width,
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFC8C8C8),
                      Color(0xFF7A7A7A),
                      Color(0xFF3A3A3A),
                      Color(0xFF9A9A9A),
                    ],
                    stops: [0.0, 0.35, 0.7, 1.0],
                  ),
                  border: Border.all(color: const Color(0xFF2A2A2A), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: hingeWidth,
                    height: barHeight,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(3),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE8E8E8),
                          Color(0xFF555555),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
