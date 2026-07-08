import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

class VendingStateNotifier extends Notifier<VendingState> {
  @override
  VendingState build() => IdleState();

  Timer? _resetTimer;

  void onSnackSelected(SnackTMP snack) {
    print('Selected snack ${snack.name}');
    state = state.onSnackSelected(snack);
  }

  void onCoinInserted(Coin coin) => state = state.onCoinInserted(coin);
  void onReturnPressed() => state = state.onReturnPressed();

  @override
  set state(VendingState newState) {
    super.state = newState;
    _resetTimer?.cancel();

    if (newState is! IdleState) {
      _resetTimer = Timer(
        Duration(seconds: 5),
        _reset,
      );
    }
  }

  void _reset() {
    state = IdleState();
  }
}
