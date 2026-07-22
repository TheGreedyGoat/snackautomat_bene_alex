import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/dusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/num_pad_display.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/number_key_pad.dart';

class NumberPadArea extends StatelessWidget {
  const NumberPadArea({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = HSVColor.fromAHSV(1, 0, 0.5, .5);
    return SizedBox(
      width: 160,
      height: 320,
      child: Rusty(
        rustLevel: RustLevel.light,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          boxShadow: [
            BoxShadow(
              color: baseColor.toColor(),
            ),
            BoxShadow(
              blurRadius: 0,
              spreadRadius: -5,
              offset: Offset(5, 5),
              color: baseColor.withValue(0).toColor(),
            ),
            BoxShadow(
              blurRadius: 0,
              spreadRadius: -5,
              offset: Offset(-5, -5),
              color: baseColor.withValue(0.8).toColor(),
            ),
            BoxShadow(
              color: baseColor.toColor(),
              blurRadius: 5,
              spreadRadius: -5,
            ),
          ],
          // color: const Color.fromARGB(255, 214, 214, 214),
        ),
        child: Dusty(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NumPadDisplay(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NumberKeyPad(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
