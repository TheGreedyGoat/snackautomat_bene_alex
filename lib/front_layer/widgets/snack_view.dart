import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_stack_widget.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/vending_display.dart';

class SnackView extends ConsumerWidget {
  const SnackView({super.key});

  // fixed size for grid + background — tweak these
  static const gridW = 900.0;
  static const gridH = 900.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: gridW,
      height: gridH,
      child: VendingDisplay(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/decoration/Metallgitter.png',
              width: gridW,
              height: gridH,
              fit: BoxFit.fill,
            ),
            Overlay(
              initialEntries: [
                OverlayEntry(builder: (_) => const _SnackGrid()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackGrid extends ConsumerWidget {
  const _SnackGrid();

  static const columns = 6;
  static const rows = 4;

  // fixed layout
  static const startX = 43.0;
  static const startY = 30.0;
  static const slotW = 121.0;
  static const slotH = 136.0;
  static const snackSize = 90.0;
  static const gateWidth = 100.0;
  static const gateOffsetY = -40.0; // how far below the snack stack
  static const labelOffsetY = -25; // how far below the snack stack

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);

    return state.when(
      loading: () => const Placeholder(color: Colors.yellow),
      error: (_, _) => const Placeholder(color: Colors.red),
      data: (state) {
        final slots = state.snackStorage;
        final selected = state.vendingState.selectedSlot;
        final cellW = snackSize > gateWidth ? snackSize : gateWidth;

        return Stack(
          children: [
            for (var i = 0; i < columns * rows && i < slots.length; i++) ...[
              Positioned(
                left: startX + (i % columns) * slotW + (slotW - cellW) / 2,
                top: startY + (i ~/ columns) * slotH,
                width: cellW,
                height: slotH,
                child: SnackStackWidget(
                  stack: slots[i],
                  snackSize: snackSize,
                  gateWidth: gateWidth,
                  gateOffsetY: gateOffsetY,
                  // left 3 cols lean right, right 3 lean left; stronger farther outfrom the middle
                  stackBias:
                      ((columns - 1) / 2 - (i % columns)) / ((columns - 1) / 3),
                  dispense:
                      state.vendingState is DispenseSnackState && selected == i,
                  onAnimationFinished: () =>
                      ref.read(snackMachineProvider.notifier).onFinished(),
                ),
              ),
              Positioned(
                left: startX + (i % columns) * slotW,
                top: startY + (i ~/ columns) * slotH + slotH + labelOffsetY,
                width: slotW,
                child: Text(
                  i.toString().padLeft(3, '0'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'FixedSys',
                    fontSize: 14,
                    height: 1,
                    letterSpacing: 2,
                    color: const Color(0xFFFFBF00).withValues(alpha: 0.95),
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
