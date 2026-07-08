import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

class IdleState extends ManualState {
  IdleState() : super(credit: 0, selectedSnack: null);

  @override
  VendingState onCoinInserted(Coin coin) {
    final newCredit = credit + coin.worth;
    return NoSelectionState(
      credit: newCredit,
    );
  }
}
