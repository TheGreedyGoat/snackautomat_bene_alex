import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';

import '../../mid_layer/models/snack.dart';

//Fake 3D thickness effect for the snack card
class ThickSnackCard extends StatelessWidget {
  final Snack snack;
  final int index;
  final double thickness;
  final int layers;

  const ThickSnackCard({
    super.key,
    required this.snack,
    required this.index,
    this.thickness = 24,
    this.layers = 14,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Color.fromARGB(
      255,
      255 - index * 10,
      191 - index * 10,
      0,
    );
    final edgeColor = Color.lerp(baseColor, Colors.black, 0.45)!;

    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = layers; i >= 1; i--)
          Transform(
            transform: Matrix4.identity()
              ..translateByDouble(0, 0, i * thickness / layers, 1),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                // darker the further back the slab is
                color: Color.lerp(edgeColor, Colors.black, i / layers * 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        SnackCard(snack: snack, index: index),
      ],
    );
  }
}

class SnackCard extends StatelessWidget {
  final Snack snack;
  final int index;

  const SnackCard({
    super.key,
    required this.snack,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: Color.fromARGB(
        255,
        255 - index * 10,
        191 - index * 10,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                snack.image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: const Color.fromARGB(90, 0, 0, 0),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snack.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      MoneyConverter.centsToEutoDisplay(snack.price),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
