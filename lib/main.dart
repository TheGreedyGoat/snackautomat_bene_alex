import 'package:flutter/material.dart';
import 'package:my_utils/utility/formatters.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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

class CoinStackDisplay extends StatefulWidget {
  const CoinStackDisplay({super.key});

  @override
  State<CoinStackDisplay> createState() => _CoinStackDisplayState();
}

class _CoinStackDisplayState extends State<CoinStackDisplay> {
  late CoinStack stack;
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    stack = CoinStack.empty();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        stack.addCoin(coinType);
                      });
                    },
                    child: Text('+'),
                  ),
                  Text(coinType.toString()),
                  Text(stack.getCoinAmount(coinType).toString()),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        stack.removeCoin(coinType);
                      });
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
                    stack.tryRemoveAmount(Formatters.doubleToInt(value, 2)),
                  );
                  setState(() {});
                }
              },
              child: Text('Remove amount'),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () => setState(() {
            stack = CoinStack.random();
          }),
          child: Text('random'),
        ),
        OutlinedButton(
          onPressed: () => setState(() {
            stack = CoinStack.empty();
          }),
          child: Text('Reset'),
        ),
      ],
    );
  }
}
