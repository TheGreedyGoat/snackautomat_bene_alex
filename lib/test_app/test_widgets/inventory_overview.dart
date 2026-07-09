import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class InventoryOverview extends ConsumerWidget {
  const InventoryOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(inventoryProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Container(), Text('Storage'), Text('Change')],
        ),
        storage.when(
          data: (data) {
            final storage = data.coinStorage;
            final change = data.changeSlot;
            return Column(
              children: Coin.values.map(
                (coin) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(coin.toString()),
                      Text(
                        storage.getCoinAmount(coin).toString(),
                      ),
                      Text(change.getCoinAmount(coin).toString()),
                    ],
                  );
                },
              ).toList(),
            );
          },
          error: (error, stackTrace) => Text('Error'),
          loading: () => Text('Loading'),
        ),
      ],
    );
  }
}
