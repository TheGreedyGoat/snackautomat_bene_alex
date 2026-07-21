import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'metal_gate.dart';
import 'snack_card.dart';

class SnackStackWidget extends StatefulWidget {
  final SnackStack stack;
  final bool dispense;
  final double gateWidth;
  final void Function() onAnimationFinished;
  const SnackStackWidget({
    super.key,
    required this.stack,
    required this.gateWidth,
    required this.onAnimationFinished,
    this.dispense = false,
  });

  @override
  State<SnackStackWidget> createState() => _SnackStackWidgetState();
}

class _SnackStackWidgetState extends State<SnackStackWidget>
    with TickerProviderStateMixin {
  static const double _cardExtent = 188;
  late int snackCount;

  late AnimationController controller;
  late AnimationController gateController;

  late Animation<double> fall;
  late Animation<double> rotation;
  late Animation<double> rotationX;
  late Animation<double> rotationY;
  late Animation<double> drift;
  late Animation<double> scale;

  final Random random = Random();

  bool removing = false;

  final GlobalKey stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    snackCount = widget.stack.count;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    gateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void didUpdateWidget(covariant SnackStackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stack.count != widget.stack.count && !removing) {
      snackCount = widget.stack.count;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    gateController.dispose();
    super.dispose();
  }

  Future<void> removeSnack() async {
    if (snackCount == 0 || removing) return;

    final box = stackKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox;

    final globalPosition = box.localToGlobal(
      Offset(0, box.size.height - _cardExtent),
    );
    final position = overlayBox.globalToLocal(globalPosition);
    final renderedRight = box.localToGlobal(Offset(box.size.width, 0)).dx;
    final widgetScale = (renderedRight - globalPosition.dx) / box.size.width;

    fall =
        Tween(
          begin: 0.0,
          end: overlayBox.size.height - position.dy + 250 * widgetScale,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInCubic,
          ),
        );

    rotation =
        Tween(
          begin: 0.0,
          end: (random.nextDouble() * .8 + .3) * (random.nextBool() ? 1 : -1),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        );

    rotationX =
        Tween(
          begin: 0.0,
          end: (random.nextDouble() * 1.2 + .8) * (random.nextBool() ? 1 : -1),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        );

    rotationY =
        Tween(
          begin: 0.0,
          end: (random.nextDouble() * .5 + .15) * (random.nextBool() ? 1 : -1),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        );

    drift =
        Tween(
          begin: 0.0,
          end: (random.nextDouble() * 140 - 70) * widgetScale,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOut,
          ),
        );

    scale =
        Tween(
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

    // open the gate, drop the snack, then close the gate again
    await gateController.forward();

    final entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: controller,
          child: ThickSnackCard(
            snack: widget.stack.snack,
            index: 0,
          ),
          builder: (_, child) {
            return Positioned(
              left: position.dx + drift.value,
              top: position.dy + fall.value,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateX(rotationX.value)
                  ..rotateY(rotationY.value)
                  ..rotateZ(rotation.value),
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                  scale: scale.value * widgetScale,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
    overlay.insert(entry);

    await controller.forward();
    entry.remove();
    await gateController.reverse();
    if (!mounted) return;
    setState(() {
      removing = false;
    });
    controller.reset();
  }

  void handleTap() {
    removeSnack();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref
            .read(snackMachineProvider.notifier)
            .setDispenseCallBack(widget.stack.snackID, removeSnack);
        return Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                // move the snacks a bit down
                child: FractionalTranslation(
                  translation: const Offset(0, 0.5),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      key: stackKey,
                      width: 200,
                      height: 216,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          for (int i = snackCount - 1; i >= 0; i--)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              bottom: i * 6.3,
                              left: i * 2,
                              child: Opacity(
                                opacity: (i == 0 && removing) ? 0 : 1,
                                child: SnackCard(
                                  snack: widget.stack.snack,
                                  index: i,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: widget.gateWidth,
                child: AnimatedBuilder(
                  animation: gateController,
                  builder: (context, child) {
                    return MetalGate(
                      open: Curves.easeInOut.transform(gateController.value),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
