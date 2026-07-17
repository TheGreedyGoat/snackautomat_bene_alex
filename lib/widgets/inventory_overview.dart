import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class InventoryOverview extends ConsumerWidget {
  const InventoryOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);
    return state.when(
      loading: () => Placeholder(color: Colors.yellow),
      error: (error, stackTrace) => Placeholder(
        color: Colors.red,
      ),
      data: (state) => Column(
        children: [
          OutlinedButton(
            onPressed: ref.read(snackMachineProvider.notifier).refillSnacks,
            child: Text('refill'),
          ),
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
                      state.coinStorage.getCoinCount(coin).toString(),
                    ),
                    Text(state.changeSlot.getCoinCount(coin).toString()),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
