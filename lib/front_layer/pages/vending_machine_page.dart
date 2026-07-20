import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_purse.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/control_pad.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/info_screen.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/inventory_overview.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/nuka_cola_sign.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty_rounded_box.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_dispense.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_view.dart';

/// The Main layout for the vending machine
class VendingMachinePage extends StatelessWidget {
  /// The Main layout for the vending machine
  const VendingMachinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: RustyRoundedBox(
                color: Color(0xffBA1724),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(child: InventoryOverview()),
                        SizedBox.square(
                          dimension: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: NukaColaSign(),
                          ),
                        ),
                        InventoryOverview(),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 500.0,
                            ),
                            child: InfoScreen(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              color: const Color.fromARGB(255, 243, 210, 196),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SnackView(),
                              ),
                            ),
                          ),
                          SizedBox(width: 300, child: ControlPad()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: SnackDispense(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100, child: CoinPurse()),
          ],
        );
      },
    );
  }
}
