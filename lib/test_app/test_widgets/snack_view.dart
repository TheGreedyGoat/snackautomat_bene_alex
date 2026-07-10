import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_card.dart';

class SnackView extends ConsumerWidget {
  const SnackView({required this.width, required this.height, super.key});
  final double width;
  final double height;
  static const dimension = 100.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);
    return showSnacks(state.snackStorage.length);
  }

  Widget showSnacks(int numSnacks) {
    final columns = max((width / dimension).floor(), 1);
    return ListView.builder(
      itemCount: (numSnacks / columns).ceil(),
      itemBuilder: (context, i) {
        return Column(
          children: [
            SizedBox(
              // height: spacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // spacing: spacing,
              children: [
                for (int j = 0; j < columns; j++)
                  if (_index(i, j, columns) < numSnacks)
                    SnackSlotCard(
                      snackIndex: _index(i, j, columns),
                      dimension: dimension,
                    )
                  else
                    SizedBox.square(
                      dimension: dimension,
                    ),
              ],
            ),
          ],
        );
      },
    );
  }

  int _index(int i, int j, int columns) {
    return j + columns * i;
  }
}
