import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

/// 'Standalone' button to let the customer trigger get their money back.
///
/// Probably deprecated, since this function is now included in the NumberPad
class ReturnButton extends ConsumerStatefulWidget {
  /// 'Standalone' button to let the customer trigger get their money back.
  ///
  /// Probably deprecated, since this function is now included in the NumberPad
  const ReturnButton({super.key});

  @override
  ConsumerState<ReturnButton> createState() => _ReturnButtonState();
}

class _ReturnButtonState extends ConsumerState<ReturnButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: isHovered ? Colors.redAccent : Colors.red,
          alignment: Alignment.center,
        ),
        onHover: (value) {
          isHovered = value;
        },
        onPressed: () {
          ref.read(snackMachineProvider.notifier).onReturnPressed();
        },
        child: Text(
          'R',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
