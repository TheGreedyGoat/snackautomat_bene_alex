import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/front_layer/pages/vending_machine_page.dart';

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
        backgroundColor: Colors.transparent,
        body: VendingMachinePage(),
      ),
    );
  }
}
