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
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 3,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      children: [
        for (int i = 1; i < 10; i++) _numberButton(i),
        _button(
          'C',
          () => notifier.clearNumPad(),
        ),
        _numberButton(0),
        _button(
          'R',
          () => notifier.onReturnPressed(),
        ),
      ],
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
