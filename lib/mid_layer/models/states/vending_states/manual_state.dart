import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// abstract class for VendingStates that wmainly wait for a user input (Insert a coin, press return etc.)
abstract class ManualState extends VendingState {
  final bool autoReset;

  /// abstract class for VendingStates that wmainly wait for a user input (Insert a coin, press return etc.)
  ManualState({
    required super.credit,
    required super.displayMessage,
    required super.numberPadState,
    required this.autoReset,
    super.selectedSlot,
    super.mode,
  }) : super(acceptsInput: true);

  @override
  VendingState onReturnPressed() {
    return credit > 0
        ? ReturnCoinsState(credit: credit)
        : IdleState(numberPadState: NumberPadState.init());
  }

  @override
  VendingState setNumPadState(NumberPadState newState) {
    final selectionValue = newState.value;
    return selectionValue == null
        ? NoSelectionState(credit: credit, numberPadState: newState)
        : PayState(
            credit: credit,
            selectedSlot: selectionValue,
            numberPadState: newState,
          );
  }
}
