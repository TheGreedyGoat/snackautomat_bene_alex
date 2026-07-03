import 'package:flutter/material.dart';

import '../models/snack.dart';

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
                      "${snack.price.toStringAsFixed(2)} €",
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
