import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/coin_dispense.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/coin_purse.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/control_pad.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_dispende.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_view.dart';

void main() {
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
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Temporary Test'),
        ),
        body: MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            color: Colors.blueGrey,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SnackView(),
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
  }
}
