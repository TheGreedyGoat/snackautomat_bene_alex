import 'dart:math';

import 'package:flutter/material.dart';

import '../models/snack.dart';
import 'snack_card.dart';

class SnackStack extends StatefulWidget {
  final Snack snack;
  final int count;

  const SnackStack({
    super.key,
    required this.snack,
    required this.count,
  });

  @override
  State<SnackStack> createState() => _SnackStackState();
}

class _SnackStackState extends State<SnackStack>
    with SingleTickerProviderStateMixin {
  late int snackCount;

  late AnimationController controller;

  late Animation<double> fall;
  late Animation<double> rotation;
  late Animation<double> drift;
  late Animation<double> scale;

  final Random random = Random();

  bool removing = false;

  final GlobalKey stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    snackCount = widget.count;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void removeSnack() {
    if (snackCount == 0 || removing) return;

    final box = stackKey.currentContext!.findRenderObject() as RenderBox;

    final position = box.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;

    fall = Tween(
      begin: 0.0,
      end: screenHeight - position.dy + 250,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInCubic,
      ),
    );

    rotation = Tween(
      begin: 0.0,
      end: (random.nextDouble() * .8 + .3) * (random.nextBool() ? 1 : -1),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    drift = Tween(
      begin: 0.0,
      end: random.nextDouble() * 140 - 70,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    scale = Tween(
      begin: 1.0,
      end: .92,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    setState(() {
      removing = true;
    });

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: controller,
          child: SnackCard(
            snack: widget.snack,
            index: 0,
          ),
          builder: (_, child) {
            return Positioned(
              left: position.dx,
              top: position.dy + fall.value,
              child: Transform.translate(
                offset: Offset(
                  drift.value,
                  0,
                ),
                child: Transform.rotate(
                  angle: rotation.value,
                  child: Transform.scale(
                    scale: scale.value,
                    child: child,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);

    controller.forward().then((_) {
      entry.remove();

      setState(() {
        snackCount--;
        removing = false;
      });

      controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: removeSnack,
      child: SizedBox(
        key: stackKey,
        width: 220,
        height: 280,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = snackCount - 1; i >= 0; i--)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: i * -6.3,
                left: i * 2,
                child: Opacity(
                  opacity: (i == 0 && removing) ? 0 : 1,
                  child: SnackCard(
                    snack: widget.snack,
                    index: i,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
