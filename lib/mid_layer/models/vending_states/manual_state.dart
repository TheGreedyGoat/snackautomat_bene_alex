import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

abstract class ManualState extends VendingState {
  ManualState({
    required super.credit,
    super.selectedSnack,
  });

  @override
  VendingState onReturnPressed() {
    return IdleState();
  }

  @override
  VendingState onCoinInserted(Coin coin) {
    //TODO: add coin to inventory
    return this;
  }

  @override
  VendingState onSnackSelected(SnackTMP snack) {
    return PayState(credit: credit, selectedSnack: snack);
  }
}
