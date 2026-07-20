import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_text.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_title.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_separation_line.dart';

/// the vending machine's main display.
///
/// Used to show any relevant information and 'guide the user through the vending process'
class InfoScreen extends ConsumerStatefulWidget {
  /// the vending machine's main display.
  ///
  /// Used to show any relevant information and 'guide the user through the vending process'
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  String title = 'NUKA COLA CORP *=* ';
  @override
  void initState() {
    super.initState();
    if (ref.read(snackMachineProvider).hasError) {
      title = 'ERROR === ';
    }
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
    return LcdDisplay(
      height: 200,
      child: state.when(
        data: (state) {
          final selectedSlot = state.getSlot(state.vendingState.selectedSlot);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LcdTitle(title),
                    LcdText(state.vendingState.credit.toString()),
                  ],
                ),
                LcdText(
                  state.vendingState.displayMessage,
                  hasError: state.vendingState.hasError,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LcdSeparationLine(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LcdText('AUSWAHL: ${state.numberPadState}'),
                        LcdText(selectedSlot?.snackName ?? '...'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LcdText(
                          'Preis: ${selectedSlot?.priceDisplay ?? '€ -.--'}',
                        ),
                        LcdText(
                          'Kredit: ${state.vendingState.creditDisplay}',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Column(
            children: [
              LcdText(title, hasError: true),

              LcdText(error.toString(), hasError: true),
            ],
          );
        },
        loading: () => LcdText('loading'),
      ),
    );
  }
}
