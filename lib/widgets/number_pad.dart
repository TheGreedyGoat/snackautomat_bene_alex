import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty.dart';

class NumberPad extends ConsumerStatefulWidget {
  const NumberPad({super.key});
  @override
  ConsumerState<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends ConsumerState<NumberPad> {
  late final SnackMachineNotifier notifier;
  static const spacing = 5.0;
  @override
  void initState() {
    super.initState();
    notifier = ref.read(snackMachineProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 400.0,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          if (index < 9) {
            return _numberButton(index + 1);
          }
          return switch (index) {
            9 => _button(
              'C',
              () => notifier.clearNumPad(),
            ),
            10 => _numberButton(0),

            11 => _button(
              'R',
              () => notifier.onReturnPressed(),
            ),
            _ => null,
          };
        },
      ),
    );
  }

  Widget _numberButton(int digit) {
    return _button(
      digit.toString(),
      () {
        notifier.inputDigit(digit);
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
