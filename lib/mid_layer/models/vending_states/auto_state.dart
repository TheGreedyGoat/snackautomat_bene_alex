import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

abstract class AutoState extends VendingState {
  AutoState({
    required super.credit,
    required super.displayMessage,
    super.selectedSlot,
    super.hasError,
  }) : super(acceptsInput: false);

  @override
  VendingState onCoinInserted(Coin coin) => this;

  @override
  VendingState onReturnPressed() => this;

  @override
  VendingState onSnackSelected(int slot) => this;

  VendingState onFinished();
  void updateInventory(InventoryNotifier inventory);
  void updateNotifier(SnackMachineNotifier notifier);
}
