import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/widgets/coin_dispense.dart';
import 'package:snackautomat_bene_alex/widgets/coin_purse.dart';
import 'package:snackautomat_bene_alex/widgets/control_pad.dart';
import 'package:snackautomat_bene_alex/widgets/info_screen.dart';
import 'package:snackautomat_bene_alex/widgets/nuka_cola_sign.dart';
import 'package:snackautomat_bene_alex/widgets/overlays/rusty.dart';
import 'package:snackautomat_bene_alex/widgets/snack_dispense.dart';
import 'package:snackautomat_bene_alex/widgets/snack_view.dart';

void runTestApp() {
  runApp(
    ProviderScope(
      child: VendingTestApp(),
    ),
  );
}

class VendingTestApp extends StatelessWidget {
  const VendingTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static const _controlPadWidth = 500.0;
  static const _dispenseHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final snackViewWidth = constraints.maxWidth - 24 - _controlPadWidth;
        final snackViewHeight = constraints.maxHeight - 8 - _dispenseHeight;
        return Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: getRustyDecoration(Colors.grey).copyWith(
                  color: const Color.fromARGB(255, 134, 11, 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: _controlPadWidth,
                              ),
                              child: InfoScreen(),
                            ),
                          ),
                        ),
                        SizedBox.square(
                          dimension: 250,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: NukaColaSign(),
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
                                child: SnackView(
                                  width: snackViewWidth,
                                  height: snackViewHeight,
                                ),
                              ),
                            ),
                          ),
                          ControlPad(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: Row(
                        children: [
                          Expanded(child: SnackDispense()),
                          CoinDispense(),
                        ],
                      ),
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

  // double _getAvailableWidth(BuildContext context){
  //   MediaQuery.of(context);
  // }
}
