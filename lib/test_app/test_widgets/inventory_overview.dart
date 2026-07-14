import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class InventoryOverview extends ConsumerWidget {
  const InventoryOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Container(), Text('Storage'), Text('Change')],
        ),
        Column(
          children: Coin.values.map(
            (coin) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(coin.toString()),
                  Text(
                    state.coinStorage.getCoinAmount(coin).toString(),
                  ),
                  Text(state.changeSlot.getCoinAmount(coin).toString()),
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
