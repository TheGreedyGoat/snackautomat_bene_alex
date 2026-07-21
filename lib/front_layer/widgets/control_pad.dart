import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_dispense.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_slit.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/num_pad_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/number_key_pad.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty_rounded_box.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/number_pad_area.dart';

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
      deocration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 210, 187),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //Main Row
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NumberPadArea(),
              SizedBox(
                width: 100,
                child: Image(
                  image: AssetImage('assets/images/nuka_world_logo.png'),
                ),
              ),
            ],
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
