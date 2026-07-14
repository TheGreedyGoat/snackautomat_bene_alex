import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// A snack is selected, but the credit is less than the snack's price.
///
/// Machine waits for further coins to be inserted
class PayState extends ManualState {
  /// A snack is selected, but the credit is less than the snack's price.
  ///
  /// Machine waits for further coins to be inserted
  PayState({
    required super.credit,
    required super.selectedSlot,
    super.displayMessage = 'Bitte bezahlen',
    super.hasError,
  });

  @override
  VendingState onCoinInserted(Coin coin) {
    return PayState(credit: credit + coin.worth, selectedSlot: selectedSlot);
  }
}
