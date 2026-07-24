import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'backgrounds_overlays/glass_pane.dart';

/// Glass door that can swing open. Hinges are on the left.
class VendingDisplay extends StatefulWidget {
  final Widget child;
  const VendingDisplay({
    super.key,
    required this.child,
  });

  @override
  State<VendingDisplay> createState() => _VendingDisplayState();
}

class _VendingDisplayState extends State<VendingDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  // door opens about 110 degrees
  late final Animation<double> _angle = Tween(begin: 0.0, end: 1.9).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
  );

  void _toggleDoor() {
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0004)
                    ..rotateY(_angle.value),
                  child: _GlassDoor(
                    showThickness: _controller.value > 0.001,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final open = _controller.value > 0.001;
                return FloatingActionButton.small(
                  heroTag: 'glassDoorButton',
                  backgroundColor: const Color(0xFF3A3A3A),
                  foregroundColor: const Color(0xFFFFBF00),
                  onPressed: _toggleDoor,
                  child: Icon(open ? Icons.meeting_room : Icons.sensor_door),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The glass part of the door, with some extra layers for fake thickness
class _GlassDoor extends StatelessWidget {
  final bool showThickness;
  //! This is the glass door
  const _GlassDoor({required this.showThickness});

  static const double _thickness = 26;
  static const int _layers = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (showThickness)
          for (int i = _layers; i >= 1; i--)
            Transform(
              transform: Matrix4.identity()
                ..translateByDouble(0, 0, i * _thickness / _layers, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
              ),
            ),
        const GlassPane(child: SizedBox.expand()),
      ],
    );
  }
}
