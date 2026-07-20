import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

/// Temporary - Shows every coin type as a button to insert into the vending machine
class CoinPurse extends ConsumerWidget {
  /// Temporary - Shows every coin type as a button to insert into the vending machine
  const CoinPurse({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final coin in Coin.values)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: CircleBorder(),
                  alignment: AlignmentGeometry.center,
                ),
                onPressed: () {
                  ref.read(snackMachineProvider.notifier).onCoinInserted(coin);
                },
                child: SizedBox.square(
                  dimension: 70,
                  child: Center(
                    child: Text(coin.toString()),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
