import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/models/snack.dart';
import 'package:snackautomat_bene_alex/widgets/snack_stack.dart';
import 'package:snackautomat_bene_alex/widgets/vending_display.dart';

class SnackView extends ConsumerWidget {
  const SnackView({required this.width, required this.height, super.key});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VendingDisplay(
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

  static const _snackImages = [
    'assets/images/Twix.png',
    'assets/images/Rafaelo.png',
    'assets/images/Pringles.png',
    'assets/images/MilkaOreo.png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);
    final slots = state.snackStorage;

    return LayoutBuilder(
      builder: (context, constraints) {
        final rasterScale = (constraints.maxWidth / 1000).clamp(0.35, 2.0);
        final spacing = 24 * rasterScale;

        return GridView.builder(
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.8,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            return FittedBox(
              fit: BoxFit.contain,
              child: SnackStack(
                snack: Snack(
                  name: slot.snackName,
                  price: slot.snackPrice / 100,
                  image: _snackImages[index % _snackImages.length],
                ),
                count: slot.amount,
                onTap: () {
                  ref
                      .read(snackMachineProvider.notifier)
                      .onSlotSelected(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}
