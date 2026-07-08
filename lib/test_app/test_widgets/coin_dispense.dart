import 'dart:math';
import 'package:flutter/material.dart';

class CoinDispense extends StatelessWidget {
  const CoinDispense({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: SizedBox.square(
        dimension: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (int i = 0; i < 6; i++)
                SizedBox(
                  height: 10,
                  width: (Random().nextDouble() * 30) + 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Random().nextBool()
                          ? Colors.amber
                          : Colors.blueGrey,
                      border: BoxBorder.all(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
