import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/widgets/coin_slit.dart';
import 'package:snackautomat_bene_alex/widgets/number_pad.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty_rounded_box.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty.dart';

///
class ControlPad extends StatelessWidget {
  ///
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context) {
    return RustyRoundedBox(
      color: Colors.blue,
      child: Column(
        children: [
          NumberPad(),
        ],
      ),
    );
  }
}
