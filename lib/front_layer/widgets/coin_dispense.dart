import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

/// The slot where returned coins will show up
class CoinDispense extends ConsumerWidget {
  /// The slot where returned coins will show up
  const CoinDispense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAs = ref.watch(snackMachineProvider);
    return stateAs.when(
      loading: () => Placeholder(),
      error: (error, stackTrace) => Placeholder(),
      data: (state) {
        final coinsList = state.changeSlot.toList();
        return GestureDetector(
          onTap: () {
            ref.read(snackMachineProvider.notifier).emptyChange();
          },
          child: Column(
            children: [
              Card.outlined(
                color: Colors.grey,
                child: SizedBox.square(
                  dimension: 70,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (int i = 0; i < min(coinsList.length, 8); i++)
                          SizedBox(
                            height: 7,
                            width: coinsList[i].coinWidth,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  // stops: [1],
                                  stops: [
                                    0.00001,
                                    0.3,
                                    0.7,
                                    0.99999,
                                  ],
                                  colors: [
                                    Colors.black,
                                    coinsList[i].coinColor,
                                    coinsList[i].coinColor,
                                    Colors.black,
                                  ],
                                ),
                                border: BoxBorder.all(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(child: Text('total: ${state.changeSlot.sumDisplay}')),
            ],
          ),
        );
      },
    );
  }
}
