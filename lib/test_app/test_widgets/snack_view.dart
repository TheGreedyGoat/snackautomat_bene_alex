import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/widgets/snack_stack_widget.dart';
import 'package:snackautomat_bene_alex/widgets/vending_display.dart';

class SnackView extends ConsumerWidget {
  const SnackView({required this.width, required this.height, super.key});
  final double width;
  final double height;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // baut neu wenn sich ein Snack ändert
    final state = ref.watch(snackMachineProvider);
    final slots = state.snackStorage;

    // damit weiß ich wieviel Platz das Raster hat
    return LayoutBuilder(
      builder: (context, constraints) {
        // Abstände skalieren ein bischen mit
        final rasterScale = (constraints.maxWidth / 1000).clamp(0.35, 2.0);
        final spacing = 24 * rasterScale;

        // beste Anzahl an Spalten suchen
        final columns = _bestColumnCount(
          itemCount: slots.length,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          spacing: spacing,
        );

        // ceil rundet die Reihen nach oben
        final rows = (slots.length / columns).ceil();

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

        return GridView.builder(
          // sollte alles reinpassen, scrollen ist also aus
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cellWidth / cellHeight,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];

            // skaliert den ganzen Snack und nicht nur das Bild
            return FittedBox(
              fit: BoxFit.contain,
              child: SnackStackWidget(
                slot: slot,
                onTap: () {
                  // Auswahl an die Automatenlogik geben
                  ref.read(snackMachineProvider.notifier).onSlotSelected(index);
                },
              ),
            );
          },
        );
      },
    );
  }

  int _bestColumnCount({
    required int itemCount,
    required double width,
    required double height,
    required double spacing,
  }) {
    if (itemCount <= 1) return 1;

    var bestColumns = 1;
    var bestScale = 0.0;

    // mehr als 6 wird zu klein
    final maxColumns = min(itemCount, 6);

    // alle Möglichkeiten einmal durch probieren
    for (var columns = 1; columns <= maxColumns; columns++) {
      final rows = (itemCount / columns).ceil();
      final cellWidth =
          (width - 2 * spacing - (columns - 1) * spacing) / columns;
      final cellHeight = (height - 2 * spacing - (rows - 1) * spacing) / rows;

      // normale Snackgröße ist 220 x 280
      final scale = min(cellWidth / 220, cellHeight / 280);

      // die gröste Variante merken
      if (scale > bestScale) {
        bestScale = scale;
        bestColumns = columns;
      }
    }

    return bestColumns;
  }
}
