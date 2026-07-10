import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/coin_dispense.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/coin_purse.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/control_pad.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_dispense.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_view.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final snackViewWidth = constraints.maxWidth - 8 - 500;
        final snackViewHeight = constraints.maxHeight - 8 - 250;
        return Column(
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(4.0),
                color: Colors.blueGrey,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: SnackView(
                              width: snackViewWidth,
                              height: snackViewHeight,
                            ),
                          ),
                          ControlPad(), // 500 - 8
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
