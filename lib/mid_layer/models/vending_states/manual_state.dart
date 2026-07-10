import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

abstract class ManualState extends VendingState {
  ManualState({
    required super.credit,
    required super.displayMessage,
    super.selectedSlot,
    super.hasError,
  }) : super(acceptsInput: true);

  @override
  VendingState onReturnPressed() {
    return ReturnCoinsState(credit: credit);
  }

  @override
  VendingState onSnackSelected(int slot) {
    return PayState(credit: credit, selectedSlot: slot);
  }
}
