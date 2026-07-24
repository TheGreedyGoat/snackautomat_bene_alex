import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/coin_purse.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/control_pad.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/info_screen_2.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/inventory_overview.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/nuka_cola_sign.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty_rounded_box.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_dispense.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_view.dart';

/// The Main layout for the vending machine
class VendingMachinePage2 extends StatelessWidget {
  /// The Main layout for the vending machine
  const VendingMachinePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: RustyRoundedBox(
                deocration: BoxDecoration(
                  color: Color(0xffBA1724),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SizedBox.square(
                          //   dimension: 200,
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.black,
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: NukaColaSign(),
                          //   ),
                          // ),
                          // InventoryOverview(),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Card(
                                      margin: const EdgeInsets.all(4.0),
                                      color: const Color.fromARGB(
                                        255,
                                        243,
                                        210,
                                        196,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SnackView(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 150, child: SnackDispense()),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 300,
                            child: Column(
                              children: [
                                SizedBox.square(
                                  dimension: 150,
                                  child: NukaColaSign(),
                                ),
                                InfoScreen2(),
                                Expanded(child: ControlPad()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Row(
                    //     children: [
                    //       // const SizedBox(width: 300, child: ControlPad()),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 150, child: SnackDispense()),
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
