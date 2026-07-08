import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class CoinPurse extends ConsumerWidget {
  const CoinPurse({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final coin in Coin.values)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(),
              alignment: AlignmentGeometry.center,
            ),
            onPressed: () {
              ref.read(vendingStateProvider.notifier).onCoinInserted(coin);
            },
            child: SizedBox.square(
              dimension: 70,
              child: Center(
                child: Text(coin.toString()),
              ),
            ),
          ),
      ],
    );
  }
}
