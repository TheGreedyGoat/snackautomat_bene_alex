import 'package:flutter/material.dart';

import 'models/snack.dart';
import 'widgets/snack_stack.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final snacks = [
      const Snack(
        name: "Twix",
        price: 1.20,
        image: "assets/images/Twix.png",
      ),
      const Snack(
        name: "Rafaelo",
        price: 2.23,
        image: "assets/images/Rafaelo.png",
      ),
      const Snack(
        name: "Pringles",
        price: 3.00,
        image: "assets/images/Pringles.png",
      ),
      const Snack(
        name: "Milka Oreo",
        price: 3.00,
        image: "assets/images/MilkaOreo.png",
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(
          255,
          90,
          78,
          78,
        ),
        body: Center(
          child: SizedBox(
            width: 1000,
            height: 900,
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.8,
              ),
              itemCount: 16,
              itemBuilder: (_, index) {
                return SnackStack(
                  snack: snacks[index % snacks.length],
                  count: 10,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
