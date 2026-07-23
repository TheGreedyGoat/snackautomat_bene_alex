import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_selection_modal.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'snack_card.dart';

class SnackStackWidget extends ConsumerStatefulWidget {
  final int stackId;
  final void Function() onAnimationFinished;
  const SnackStackWidget({
    super.key,
    required this.stackId,
    required this.onAnimationFinished,
  });
  @override
  ConsumerState<SnackStackWidget> createState() => _SnackStackWidgetState();
}

class _SnackStackWidgetState extends ConsumerState<SnackStackWidget>
    with SingleTickerProviderStateMixin {
  static const double _cardExtent = 188;
  int get snackCount {
    int count = 0;
    ref.watch(snackMachineProvider).whenData(
      (state) {
        count = state.getSlot(widget.stackId)!.count;
      },
    );

    return count;
  }

  late AnimationController controller;

  late Animation<double> fall;
  late Animation<double> rotation;
  late Animation<double> rotationX;
  late Animation<double> rotationY;
  late Animation<double> drift;
  late Animation<double> scale;

  final Random random = Random();

  bool removing = false;

  final GlobalKey stackKey = GlobalKey();

  int get stackID => widget.stackId;

  SnackStack get stack {
    SnackStack? stack;
    ref
        .watch(snackMachineProvider)
        .whenData(
          (value) => stack = value.getSlot(stackID),
        );
    assert(stack != null, 'Stack $stackID not fount for SnackStackWidget');
    return stack!;
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didUpdateWidget(covariant SnackStackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.stackId.count != widget.stackId.count && !removing) {
    //   snackCount = widget.stackId.count;
    // }
  }

  @override
  void dispose() {
    controller.dispose();
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

    final entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: controller,
          child: ThickSnackCard(
            snackIndex: stack.snackIndex!,
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
    if (!mounted) return;
    setState(() {
      // snackCount--;
      removing = false;
    });
    // widget.onAnimationFinished();
    controller.reset();
    print('Remove has finished!');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref
            .read(snackMachineProvider.notifier)
            .setDispenseCallBack(stackID, removeSnack);
        return GestureDetector(
          onTap: () async {
            final int? snackIndex = await showModalBottomSheet<int>(
              context: context,
              builder: (context) => SnackSelectionModal(),
            );
            if (snackIndex == null) return;
            ref
                .read(snackMachineProvider.notifier)
                .setSnackSlot(widget.stackId, snackIndex);
          },
          child: SizedBox(
            key: stackKey,
            width: 200,
            height: 216,
            child: stack.isNotEmpty
                ? Stack(
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
                              snackIndex: stack.snackIndex!,
                              slotID: widget.stackId,
                            ),
                          ),
                        ),
                    ],
                  )
                : Card(
                    color: Colors.grey,
                  ),
          ),
        );
      },
    );
  }
}
