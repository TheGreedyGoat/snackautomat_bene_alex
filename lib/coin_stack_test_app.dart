import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/utility/formatters.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/coin_stack_notifier.dart';

final coinStackTestProvider = NotifierProvider(
  () => CoinStackNotifier(),
);

void main() {
  runApp(
    ProviderScope(
      child: CoinStackTestApp(),
    ),
  );
}

///
class CoinStackTestApp extends StatelessWidget {
  ///
  const CoinStackTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CoinStackDisplay(),
        ),
      ),
    );
  }
}

class CoinStackDisplay extends ConsumerStatefulWidget {
  const CoinStackDisplay({super.key});

  @override
  ConsumerState<CoinStackDisplay> createState() => _CoinStackDisplayState();
}

class _CoinStackDisplayState extends ConsumerState<CoinStackDisplay> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final stack = ref.watch(coinStackTestProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(stack.sumDisplay),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final coinType in Coin.values)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(coinStackTestProvider.notifier)
                          .addCoin(coinType);
                    },
                    child: Text('+'),
                  ),
                  Text(coinType.toString()),
                  Text(stack.getCoinAmount(coinType).toString()),

                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(coinStackTestProvider.notifier)
                          .removeCoin(coinType);
                    },
                    child: Text('-'),
                  ),
                ],
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                inputFormatters: [Formatters.fixedDigitsDoubleFormatter(2)],
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? value = double.tryParse(
                  controller.text.replaceAll(',', '.'),
                );
                if (value != null) {
                  print(
                    ref
                        .read(coinStackTestProvider.notifier)
                        .tryRemoveAmount(Formatters.doubleToInt(value, 2)),
                  );
                }
              },
              child: Text('Remove amount'),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () => setState(
            () => ref.read(coinStackTestProvider.notifier).setRandom(),
          ),
          child: Text('random'),
        ),
        OutlinedButton(
          onPressed: () =>
              setState(() => ref.read(coinStackTestProvider.notifier).clear()),
          child: Text('Reset'),
        ),
      ],
    );
  }
}
