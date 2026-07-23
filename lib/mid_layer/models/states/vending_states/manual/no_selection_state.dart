import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// The machine has a credit > 0 but no snack is selected
class NoSelectionState extends ManualState {
  /// The machine has a credit > 0 but no snack is selected
  NoSelectionState({
    required super.credit,
    required super.numberPadState,
    super.displayMessage = 'Bitte wählen Sie',
    super.mode,
  }) : super(autoReset: true);

  @override
  VendingState onCoinInserted(Coin coin) {
    final newCredit = credit + coin.worth;
    print('new Credit: $newCredit in NoSelection');
    return NoSelectionState(credit: newCredit, numberPadState: numberPadState);
  }
}
