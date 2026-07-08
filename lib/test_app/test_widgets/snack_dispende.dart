import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackDispense extends StatelessWidget {
  const SnackDispense({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: SizedBox.expand(child: Text('Eject')),
    );
  }
}
