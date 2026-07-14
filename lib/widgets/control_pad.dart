import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/widgets/coin_slit.dart';
import 'package:snackautomat_bene_alex/widgets/number_pad.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty.dart';

///
class ControlPad extends StatelessWidget {
  ///
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: getRustyDecoration(Colors.red).copyWith(
        color: const Color.fromARGB(255, 126, 10, 2),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 10)],
      ),
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CoinSlit(),
                // ReturnButton(),
              ],
            ),
            // InventoryOverview(),
            NumberPad(),
          ],
        ),
      ),
    );
  }
}
