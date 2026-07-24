import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/nuka_cola_ascii.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_text.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_title.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_separation_line.dart';

/// the vending machine's main display.
///
/// Used to show any relevant information and 'guide the user through the vending process'
class InfoScreen2 extends ConsumerStatefulWidget {
  /// the vending machine's main display.
  ///
  /// Used to show any relevant information and 'guide the user through the vending process'
  const InfoScreen2({super.key});

  @override
  ConsumerState<InfoScreen2> createState() => _InfoScreen2State();
}

class _InfoScreen2State extends ConsumerState<InfoScreen2> {
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
          final selectedSnack = selectedSlot?.snack;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LcdTitle(title),
                // LcdText('${state.vendingState.runtimeType}'),
                Row(
                  children: [
                    Expanded(
                      child: _textArea([
                        LcdText(
                          state.vendingState.displayMessage,
                          mode: state.vendingState.mode,
                          maxLines: null,
                          softWrap: true,
                        ),
                        LcdText(
                          selectedSnack?.name != null
                              ? 'Ihre Wahl: ${selectedSnack!.name}'
                              : '',
                          softWrap: true,
                          maxLines: null,
                        ),
                      ]),
                    ),
                    const NukaColaAscii(
                      fontSize: 10,
                    ),
                  ],
                ),
                LcdSeparationLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LcdText(
                          selectedSlot?.priceDisplay ?? '-,--',
                          fontSize: 15,
                        ),
                        LcdText(
                          'PRS',
                          fontSize: 15,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LcdText(
                          selectedSlot?.count.toString() ?? '---',
                          fontSize: 15,
                        ),
                        LcdText(
                          'STK',
                          fontSize: 15,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LcdText(
                          state.vendingState.creditDisplay,
                          fontSize: 15,
                        ),
                        LcdText(
                          'CRD',
                          fontSize: 15,
                        ),
                      ],
                    ),
                  ],
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     LcdSeparationLine(),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         LcdText('AUSWAHL: ${state.numberPadState}'),
                //         LcdText('STK: ${selectedSlot?.count ?? '---'}'),
                //       ],
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         LcdText(
                //           'Preis: ${selectedSlot?.priceDisplay ?? '€ -.--'}',
                //         ),
                //         LcdText(
                //           'Kredit: ${state.vendingState.creditDisplay}',
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Column(
            children: [
              LcdText(
                title,
                mode: LcdMessageMode.error,
              ),

              LcdText(error.toString(), mode: LcdMessageMode.error),
            ],
          );
        },
        loading: () => LcdText(
          'loading',
          mode: LcdMessageMode.warning,
        ),
      ),
    );
  }

  Widget _textArea(List<Widget> lines) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
  }
}
