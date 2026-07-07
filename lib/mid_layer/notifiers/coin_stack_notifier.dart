import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';

class CoinStackNotifier extends Notifier<CoinStack> {
  @override
  CoinStack build() {
    return CoinStack.empty();
  }

  void addCoin(Coin coinType) {
    final newState = state.fullCopy;
    newState.addCoin(coinType);
    state = newState;
  }

  void removeCoin(Coin coinType) {
    final newState = state.fullCopy;
    newState.removeCoin(coinType);
    state = newState;
  }

  CoinStack? tryRemoveAmount(int amount) {
    final CoinStack newState = state.fullCopy;
    final CoinStack change = CoinStack.empty();

    while (amount >= 0.01) {
      Coin? nextToTransfer = newState.getHighestCoinBelowAmount(amount);
      if (nextToTransfer == null) {
        return null;
      } else {
        change.addCoin(nextToTransfer);
        newState.removeCoin(nextToTransfer);
        amount -= nextToTransfer.worthInCents;
      }
    }
    state = newState;
    return change;
  }

  void setRandom() {
    state = CoinStack.random();
  }

  void clear() => state = CoinStack.empty();
}
