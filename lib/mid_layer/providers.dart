import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/vending_state_notifier.dart';

// final vendingStateProvider = NotifierProvider(
//   () => VendingStateNotifier(),
// );

// final inventoryProvider = AsyncNotifierProvider(
//   () => InventoryNotifier(),
// );

final snackMachineProvider = NotifierProvider(
  () => SnackMachineNotifier(),
);
