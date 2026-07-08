import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

class NoSelectionState extends ManualState {
  NoSelectionState({required super.credit});

  @override
  VendingState onCoinInserted(Coin coin) {
    final newCredit = credit + coin.worth;
    return NoSelectionState(
      credit: newCredit,
    );
  }
}
