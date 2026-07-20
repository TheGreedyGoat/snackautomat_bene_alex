import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';

/// The slit to insert the coin to (not operational yet)
class CoinSlit extends StatelessWidget {
  /// The slit to insert the coin to (not operational yet)
  const CoinSlit({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 1,
            color: Colors.white,
            offset: Offset(-1, -1),
          ),
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Rusty(
        color: Colors.black,
        borderRadius: 10.0,
        child: SizedBox.square(
          dimension: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Rusty(
                color: Colors.grey,
                boxShape: BoxShape.circle,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: Offset(-1, -1),
                            ),
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.white,
                              offset: Offset(1, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
