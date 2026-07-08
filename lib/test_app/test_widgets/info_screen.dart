import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendingStateProvider);
    return Card(
      color: Colors.black,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  green('VAULT TECH INDUSTRIES'),
                  green('(${state.runtimeType})'),
                  SizedBox(
                    height: 1,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              green('AUSWAHL: ${state.selectedSnack?.name ?? '---'}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  green(
                    'Preis: ${state.selectedSnack != null ? MoneyConverter.centsToEutoDisplay(state.selectedSnack!.price) : '-.--'}',
                  ),
                  green(
                    'Kredit: ${MoneyConverter.centsToEutoDisplay(state.credit)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text green(String data) => Text(
    data,
    style: TextStyle(color: Colors.green),
  );
}
