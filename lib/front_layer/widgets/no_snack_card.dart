import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/dusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';

class NoSnackCard extends StatelessWidget {
  const NoSnackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox.square(
        dimension: 180,
        child: Rusty(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Dusty(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/images/no_snack.png',
                opacity: AlwaysStoppedAnimation(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
