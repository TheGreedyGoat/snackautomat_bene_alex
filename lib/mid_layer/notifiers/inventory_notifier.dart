import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_machine_inventory.dart';

const List<SnackTMP> exampleSnacks = [
  SnackTMP(name: 'Nuka Cola', amount: 10, price: 250),
  SnackTMP(name: 'Nuka Cola Quantum', amount: 10, price: 450),
  SnackTMP(name: 'Rad Away', amount: 10, price: 430),
  SnackTMP(name: 'Stimpack', amount: 10, price: 630),
  SnackTMP(name: 'Jet', amount: 10, price: 500),
  SnackTMP(name: 'Buffout', amount: 10, price: 500),
  SnackTMP(name: 'Mentats', amount: 10, price: 500),
  SnackTMP(name: 'Med-x', amount: 10, price: 500),
  SnackTMP(name: 'Psycho', amount: 10, price: 500),
];

class InventoryNotifier extends AsyncNotifier<SnackMachineInventory> {
  @override
  FutureOr<SnackMachineInventory> build() => SnackMachineInventory(
    coinStorage: CoinStack.random(),
    snackStorage: [...exampleSnacks],
  );
}
