import 'dart:math';
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
    // Rahmen und Glasscheibe kommen hier drum
    return VendingDisplay(
      // damit der fallende Snack vor den anderen ist
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => const _SnackGrid(),
          ),
        ],
      ),
    );
  }
}

class _SnackGrid extends ConsumerWidget {
  const _SnackGrid();

  // festes Raster: immer 4x4 Plätze
  static const int columns = 4;
  static const int rows = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // baut neu wenn sich ein Snack ändert
    final state = ref.watch(snackMachineProvider);
    // damit weiß ich wieviel Platz das Raster hat
    return state.when(
      loading: () => Placeholder(color: Colors.yellow),
      error: (error, stackTrace) => Placeholder(
        color: Colors.red,
      ),
      data: (state) {
        final slots = state.snackStorage;
        print('Slots count: ${slots.length}');
        return LayoutBuilder(
          builder: (context, constraints) {
            // Abstände skalieren ein bischen mit
            final rasterScale = (constraints.maxWidth / 1000).clamp(0.35, 2.0);
            final spacing = 10 * rasterScale;

            final cellWidth = max(
              1.0,
              (constraints.maxWidth - 2 * spacing - (columns - 1) * spacing) /
                  columns,
            );

            final cellHeight = max(
              1.0,
              (constraints.maxHeight - 2 * spacing - (rows - 1) * spacing - 1) /
                  rows,
            );

            final selected = state.vendingState.selectedSlot;
            return GridView.builder(
              // sollte alles reinpassen, scrollen ist also aus
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(spacing),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: max(cellWidth / cellHeight, 0.5),
              ),
              // immer alle 16 Zellen, auch wenn weniger Snacks da sind
              itemCount: columns * rows,
              itemBuilder: (context, index) {
                // leere Plätze bleiben einfach frei
                if (index >= slots.length) {
                  return const SizedBox.shrink();
                }

                final slot = slots[index];
                final stackWidget = SnackStackWidget(
                  stack: slot,
                  dispense:
                      state.vendingState is DispenseSnackState &&
                      selected == index,
                  onAnimationFinished: () =>
                      ref.read(snackMachineProvider.notifier).onFinished(),
                );

                // skaliert den ganzen Snack und nicht nur das Bild
                return FittedBox(fit: BoxFit.contain, child: stackWidget);
              },
            );
          },
        );
      },
    );
  }
}
