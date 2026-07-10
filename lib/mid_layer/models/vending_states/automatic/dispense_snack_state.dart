import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

class DispenseSnackState extends AutoState {
  DispenseSnackState({
    required super.credit,
    required super.selectedSlot,
    super.displayMessage = 'Warenausgabe...',
    super.hasError,
  }) {
    assert(selectedSlot != null);
  }

  @override
  VendingState onFinished() =>
      credit == 0 ? IdleState() : NoSelectionState(credit: credit);

  @override
  void updateInventory(InventoryNotifier inventory) {
    inventory.dispenseSnack(selectedSlot!);
  }

  @override
  void updateNotifier(SnackMachineNotifier notifier) {
    notifier.dispenseSnack(selectedSlot!);
  }
}
