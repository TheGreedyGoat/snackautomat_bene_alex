import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

class ReturnCoinsState extends AutoState {
  ReturnCoinsState({
    required super.credit,
    super.displayMessage = 'Rückgabe...',
    super.hasError,
  });

  @override
  VendingState onFinished() => IdleState();

  @override
  void updateInventory(InventoryNotifier inventory) {
    inventory.dispenseChange(credit);
  }

  @override
  void updateNotifier(SnackMachineNotifier notifier) {
    if (!notifier.tryDispenseChange()) {
      throw ('Error while Retuning Coins: Tried dispensing impossible credit $credit');
    }
  }
}
