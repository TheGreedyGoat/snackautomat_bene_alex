import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

class NoSelectionState extends ManualState {
  NoSelectionState({required super.credit});

  @override
  VendingState onCoinInserted(Coin coin) {
    final newCredit = credit + coin.worth;
    print('new Credit: $newCredit in NoSelection');
    return NoSelectionState(
      credit: newCredit,
    );
  }

  @override
  VendingState onSnackSelected(int slot) {
    return super.onSnackSelected(slot);
  }
}
