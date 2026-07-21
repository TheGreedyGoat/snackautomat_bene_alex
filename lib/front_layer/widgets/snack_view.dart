import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_stack_widget.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/vending_display.dart';

class SnackView extends ConsumerWidget {
  const SnackView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // frame + glass come from VendingDisplay
    return VendingDisplay(
      // metal grid in the back, snacks on top, glass is in VendingDisplay
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/decoration/Metallgitter.png',
            fit: BoxFit.fill,
          ),
          // overlay so the falling snack can go in front of the others
          Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => const _SnackGrid(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnackGrid extends ConsumerWidget {
  const _SnackGrid();

  // fixed grid: 6 columns, 4 rows
  static const int columns = 6;
  static const int rows = 4;

  // edges of each slot, measured from the metal grid image
  // so the snacks sit in the dark holes and not on the bars
  static const List<double> _colLefts = [
    90 / 1254,
    256 / 1254,
    444 / 1254,
    636 / 1254,
    829 / 1254,
    1015 / 1254,
  ];
  static const List<double> _colRights = [
    232 / 1254,
    420 / 1254,
    612 / 1254,
    805 / 1254,
    991 / 1254,
    1228 / 1254,
  ];
  static const List<double> _rowTops = [
    22 / 1254,
    303 / 1254,
    600 / 1254,
    893 / 1254,
  ];
  static const List<double> _rowBottoms = [
    288 / 1254,
    578 / 1254,
    873 / 1254,
    1163 / 1254,
  ];

  // middle of the shelf edges (for the number stickers)
  static const List<double> _shelfMids = [
    0.2356,
    0.4697,
    0.7041,
    0.9370,
  ];

  /// Puts one snack slot in the middle of its hole.
  /// All slots use the same width (smallest hole) so the gates look the same.
  Widget _slotAt({
    required int index,
    required double width,
    required double height,
    required double slotWidth,
    required Widget child,
  }) {
    final col = index % columns;
    final row = index ~/ columns;
    final cellLeft = _colLefts[col] * width;
    final cellTop = _rowTops[row] * height;
    final cellW = (_colRights[col] - _colLefts[col]) * width;
    final cellH = (_rowBottoms[row] - _rowTops[row]) * height;

    // tiny fixes so it lines up better with the picture
    final nudgeDown = height * 0.01;
    final nudgeLeft = col == columns - 1 ? width * 0.022 : 0.0;

    return Positioned(
      left: cellLeft + (cellW - slotWidth) / 2 - nudgeLeft,
      top: cellTop + cellH * 0.04 + nudgeDown,
      width: slotWidth,
      height: cellH * 0.78,
      child: child,
    );
  }

  /// Number sticker on the shelf, looks like it's stuck on the metal.
  Widget _shelfLabel({
    required int index,
    required double width,
    required double height,
  }) {
    final col = index % columns;
    final row = index ~/ columns;
    final cellLeft = _colLefts[col] * width;
    final cellW = (_colRights[col] - _colLefts[col]) * width;
    final nudgeLeft = col == columns - 1 ? width * 0.022 : 0.0;

    final labelW = cellW * 0.78;
    final labelH = height * 0.034;
    final left = cellLeft + (cellW - labelW) / 2 - nudgeLeft;
    final top = _shelfMids[row] * height - labelH / 2;

    return Positioned(
      left: left,
      top: top,
      width: labelW,
      height: labelH,
      child: _SlotShelfSticker(
        label: index.toString().padLeft(3, '0'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);
    return state.when(
      loading: () => Placeholder(color: Colors.yellow),
      error: (error, stackTrace) => Placeholder(
        color: Colors.red,
      ),
      data: (state) {
        final slots = state.snackStorage;
        final selected = state.vendingState.selectedSlot;

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // same width for every slot/gate = width of the smallest hole
            var minCellW = double.infinity;
            for (var c = 0; c < columns; c++) {
              final cellW = (_colRights[c] - _colLefts[c]) * w;
              if (cellW < minCellW) minCellW = cellW;
            }
            final slotWidth = minCellW * 0.92;

            return Stack(
              children: [
                for (int index = 0; index < columns * rows; index++)
                  if (index < slots.length) ...[
                    _slotAt(
                      index: index,
                      width: w,
                      height: h,
                      slotWidth: slotWidth,
                      child: SnackStackWidget(
                        stack: slots[index],
                        gateWidth: slotWidth,
                        dispense: state.vendingState is DispenseSnackState &&
                            selected == index,
                        onAnimationFinished: () => ref
                            .read(snackMachineProvider.notifier)
                            .onFinished(),
                      ),
                    ),
                    _shelfLabel(index: index, width: w, height: h),
                  ],
              ],
            );
          },
        );
      },
    );
  }
}

/// Small metal looking sticker for the slot number.
class _SlotShelfSticker extends StatelessWidget {
  final String label;

  const _SlotShelfSticker({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A4A4A),
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
        border: Border.all(color: const Color(0xFF6A6A6A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'FixedSys',
                fontSize: 42,
                height: 1,
                letterSpacing: 3,
                color: const Color(0xFFFFBF00).withValues(alpha: 0.95),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    offset: const Offset(1, 1),
                    blurRadius: 0,
                  ),
                  Shadow(
                    color: const Color(0xFFFFBF00).withValues(alpha: 0.35),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
