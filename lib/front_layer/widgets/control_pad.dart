import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_dispense.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_slit.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/num_pad_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/number_pad.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty_rounded_box.dart';

/// contains all elements for the customer to interact with the machine such as
///
/// number pad, coin slit, Returtn button
class ControlPad extends StatelessWidget {
  /// contains all elements for the customer to interact with the machine such as
  ///
  /// number pad, coin slit, Returtn button
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context) {
    return RustyRoundedBox(
      color: const Color.fromARGB(255, 228, 210, 187),

      child: Row(
        //Main Row
        children: [
          Expanded(
            child: SizedBox(
              width: 150,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NumPadDisplay(),
                  Expanded(child: NumberPad()),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [CoinSlit(), CoinDispense()],
          ),
        ],
      ),
    );
  }
}
