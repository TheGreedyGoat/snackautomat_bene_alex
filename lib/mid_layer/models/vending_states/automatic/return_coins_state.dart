import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';

class ReturnCoinsState extends AutoState {
  ReturnCoinsState({required super.credit});

  @override
  VendingState onFinished() => IdleState();

  @override
  void updateInventory(InventoryNotifier inventory) {
    inventory.tryGetChange(credit);
  }
}
