import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

abstract class ManualState extends VendingState {
  ManualState({
    required super.credit,
    super.selectedSlot,
  }) : super(acceptsInput: true);

  @override
  VendingState onReturnPressed() {
    return IdleState();
  }

  @override
  VendingState onSnackSelected(int slot) {
    return PayState(credit: credit, selectedSlot: slot);
  }
}
