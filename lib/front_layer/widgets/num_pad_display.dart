import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_text.dart';

/// A small seperate LCD display to show the current input from the number pad
class NumPadDisplay extends ConsumerWidget {
  /// A small seperate LCD display to show the current input from the number pad
  const NumPadDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);

    return LcdDisplay(
      height: 50,
      child: Center(
        child: LcdText(
          state.when(
            data: (data) => data.numberPadState.toString(),
            error: (error, stackTrace) => 'ERROR',
            loading: () => '***',
          ),
        ),
      ),
    );
  }
}
