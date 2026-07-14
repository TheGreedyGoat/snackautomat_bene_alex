import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// abstract class for VendingStates that wmainly wait for a user input (Insert a coin, press return etc.)
abstract class ManualState extends VendingState {
  /// abstract class for VendingStates that wmainly wait for a user input (Insert a coin, press return etc.)
  ManualState({
    required super.credit,
    required super.displayMessage,
    super.selectedSlot,
    super.hasError,
  }) : super(acceptsInput: true);

  @override
  VendingState onReturnPressed() {
    return credit > 0 ? ReturnCoinsState(credit: credit) : IdleState();
  }

  @override
  VendingState onSnackSelected(int slot) {
    return PayState(credit: credit, selectedSlot: slot);
  }
}
