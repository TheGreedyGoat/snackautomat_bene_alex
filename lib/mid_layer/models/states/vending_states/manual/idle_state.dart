import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// the default state, the machine is currently resting
class IdleState extends ManualState {
  /// the default state, the machine is currently resting
  IdleState({super.displayMessage = 'Willkommen!', super.hasError})
    : super(credit: 0, selectedSlot: null);

  @override
  VendingState onCoinInserted(Coin coin) {
    final newCredit = credit + coin.worth;
    return NoSelectionState(
      credit: newCredit,
    );
  }
}
