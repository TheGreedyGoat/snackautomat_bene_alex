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
    if (ref.read(snackMachineProvider).hasError) {
      title = ' ERROR ===' * 5;
    }
    super.initState();
    timer = Timer.periodic(
      Duration(milliseconds: 500),
      (timer) {
        scrollTitle();
      },
    );
  }

  void scrollTitle() {
    final lastChar = title[title.length - 1];
    title = title.replaceRange(title.length - 1, null, '');
    setState(() {
      title = '$lastChar$title';
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(snackMachineProvider);

    return state.when(
      loading: () => _screen(
        Center(
          child: _text('loading'),
        ),
      ),
      error: (error, stackTrace) {
        print(error);
        // print(stackTrace);
        return _screen(
          Column(
            children: [
              _separationLine,
              _text(title, 30, true),
              _separationLine,
              _text(error.toString(), 20, true),
            ],
          ),
        );
      },
      data: (state) {
        final selectedSlot = state.getSlot(state.vendingState.selectedSlot);
        return _screen(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _separationLine,
                    _text(title, 30),
                    _separationLine,
                    _text(state.vendingState.credit.toString()),
                  ],
                ),
                _text(
                  state.vendingState.displayMessage,
                  null,
                  state.vendingState.hasError,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _separationLine,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _text('AUSWAHL: ${state.numberPadState}', 30),
                        _text('${selectedSlot?.snackName ?? ''}', 30),
                      ],
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
        );

        // Card(
        //   color: Colors.black,
        //   child: SizedBox(
        //     height: 250,
        //     child: Stack(
        //       fit: StackFit.expand,
        //       children: [

        //         GlassPane(),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }

  Widget _screen(Widget content) => Card(
    color: Colors.black,
    child: SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          GlassPane(),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget get _separationLine => SizedBox(
    height: 1,
    child: Container(
      color: Colors.green,
    ),
  );

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
