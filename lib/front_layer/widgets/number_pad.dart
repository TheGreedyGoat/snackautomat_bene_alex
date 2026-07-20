import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';

/// A custom number pad for the customer to select a snack
///
/// Includes a return coins button.
class NumberPad extends ConsumerWidget {
  /// A custom number pad for the customer to select a snack
  ///
  /// Includes a return coins button.
  const NumberPad({super.key});

  static const _spacing = 5.0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 3,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
      ),
      children: [
        for (int i = 1; i < 10; i++) _numberButton(i, ref),
        _button(
          'C',
          () => ref.read(snackMachineProvider.notifier).clearNumPad(),
        ),
        _numberButton(0, ref),
        _button(
          'R',
          () => ref.read(snackMachineProvider.notifier).onReturnPressed(),
        ),
      ],
    );
  }

  Widget _numberButton(int digit, WidgetRef ref) {
    return _button(
      digit.toString(),
      () {
        ref.read(snackMachineProvider.notifier).inputDigit(digit);
      },
    );
  }

  Widget _button(String label, void Function() onPressed) => Rusty(
    borderRadius: 5.0,
    color: Colors.blueGrey,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5.0),
      ),

      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
