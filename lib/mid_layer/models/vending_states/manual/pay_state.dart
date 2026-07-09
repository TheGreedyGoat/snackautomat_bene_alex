import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

class PayState extends ManualState {
  PayState({required super.credit, required super.selectedSlot});

  @override
  VendingState onCoinInserted(Coin coin) {
    return PayState(credit: credit + coin.worth, selectedSlot: selectedSlot);
  }
}
