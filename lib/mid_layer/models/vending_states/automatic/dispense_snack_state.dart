import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';

class DispenseSnackState extends AutoState {
  DispenseSnackState({required super.credit, required super.selectedSlot}) {
    assert(selectedSlot != null);
  }

  @override
  VendingState onFinished() => NoSelectionState(credit: credit);

  @override
  void updateInventory(InventoryNotifier inventory) {
    inventory.dispenseSnack(selectedSlot!);
  }
}
