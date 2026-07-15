import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/widgets/glass_pane.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  late final Timer timer;
  String title = 'NUKA COLA *=* ' * 5;
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
    final state = ref.watch(snackMachineProvider);
    final selectedSlot = state.getSlot(state.vendingState.selectedSlot);

    return Card(
      color: Colors.black,
      child: SizedBox(
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                      _text(title, 30),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  _text(
                    'AUSWAHL: ${state.numberPadState}',
                  ),
                  _text('${selectedSlot?.snackName ?? ''}'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _text(
                        state.vendingState.displayMessage,
                        null,
                        state.vendingState.hasError,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _text(
                            'Preis: ${selectedSlot?.priceDisplay ?? '--,-'}',
                          ),
                          _text(
                            'Kredit: ${state.vendingState.creditDisplay}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GlassPane(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Text _text(String data, [double? fontSize, bool hasError = false]) => Text(
    data,
    style: TextStyle(
      color: hasError ? Colors.red : Colors.green,
      fontFamily: 'FixedSys',
      fontSize: fontSize ?? 20,
    ),
    overflow: TextOverflow.clip,
    softWrap: false,
    maxLines: 1,
  );
}
