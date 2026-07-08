import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';

/// Notifier for the [CoinStack] class
class CoinStackNotifier extends Notifier<CoinStack> {
  @override
  CoinStack build() {
    return CoinStack.empty();
  }

  /// Add one coin of the specified type
  void addCoin(Coin coinType) =>
      state = state.copyWithDifference({coinType: 1});

  /// remove one coin of the specified type, if the stack has at least one
  bool removeCoin(Coin coinType) {
    final canRemove = state.hasCoinOfType(coinType);
    if (canRemove) {
      state = state.copyWithDifference({coinType: -1});
    }
    return canRemove;
  }

  /// checks if there is any combination of coins with in the stack, that adds up to the passed [amount]
  ///
  /// - if there is, the combination with the least amount of coins is removed from the stack and the removed coins get returned as a new [CoinStack]
  /// - if not, null is returned
  CoinStack? tryRemoveAmount(int amount) {
    final CoinStack newState = state.fullCopy;
    final CoinStack change = CoinStack.empty();

    while (amount >= 0.01) {
      Coin? nextToRemove = newState.tryGetHighestCoinBelowAmount(amount);
      if (nextToRemove == null) {
        return null;
      } else {
        change.addCoin(nextToRemove);
        newState.removeCoin(nextToRemove);
        amount -= nextToRemove.worth;
      }
    }
    state = newState;
    return change;
  }

  /// Creates a Coin Stack wich has a random amount of [1-10] coins of each type
  void setRandom() {
    state = CoinStack.random();
  }

  /// Set all coins to 0
  void clear() => state = CoinStack.empty();

  /// set the state to a completely new value
  ///
  /// Mainly for test purposes
  void setStack(Map<Coin, int> newCoins) {
    state = CoinStack.withCoins(newCoins);
  }
}
