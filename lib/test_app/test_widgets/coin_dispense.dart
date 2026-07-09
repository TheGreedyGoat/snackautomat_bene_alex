import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class CoinDispense extends ConsumerWidget {
  const CoinDispense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryProvider);
    return state.when(
      data: (data) => GestureDetector(
        onTap: () {
          ref.read(inventoryProvider.notifier).emptyChange();
        },
        child: Column(
          children: [
            Card.outlined(
              child: SizedBox.square(
                dimension: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (
                        int i = 0;
                        i < min(data.changeSlot.totalCoins, 8);
                        i++
                      )
                        SizedBox(
                          height: 10,
                          width: (Random().nextDouble() * 30) + 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Random().nextBool()
                                  ? Colors.amber
                                  : Colors.blueGrey,
                              border: BoxBorder.all(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Text('total: ${data.changeSlot.sumDisplay}'),
          ],
        ),
      ),
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}
