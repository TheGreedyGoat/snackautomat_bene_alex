import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  late final Timer timer;
  String title = 'NUKA COLA =*= ' * 5;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(milliseconds: 500),
      (timer) {
        scrollTitle();
      },
    );
  }

  void scrollTitle() {
    setState(() {
      final lastChar = title[title.length - 1];
      title = title.replaceRange(title.length - 1, null, '');
      title = '$lastChar$title';
    });
  }

  @override
  Widget build(BuildContext context) {
    final vendingState = ref.watch(vendingStateProvider);
    final int? index = vendingState.selectedSlot;
    final String credit = vendingState.creditDisplay;
    String name = 'noData';
    String price = 'noData';
    ref.watch(inventoryProvider).whenData(
      (value) {
        name = value.getNameOfSnack(index);
        final p = value.getPrice(index);
        price = p == null ? '-,--' : MoneyConverter.centsToEutoDisplay(p);
      },
    );

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
                  green(title, 30),
                  SizedBox(
                    height: 1,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              green(
                'AUSWAHL: $name',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  green(
                    'Preis: $price',
                  ),
                  green(
                    'Kredit: $credit',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Text green(String data, [double? fontSize]) => Text(
    data,
    style: TextStyle(color: Colors.green, fontSize: fontSize),
    overflow: TextOverflow.clip,
    softWrap: false,
    maxLines: 1,
  );
}
