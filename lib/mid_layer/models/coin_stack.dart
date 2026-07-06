import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';

/// Eine Ansammlung von Münzen.
/// Speichert, wie viele von jeder Münzart enthalten sind.
///
class CoinStack {
  /// Eine Ansammlung von Münzen.
  /// Speichert, wie viele von jeder Münzart enthalten sind.
  ///
  CoinStack.empty()
    : _coins = {
        Coin.euro2: 0,
        Coin.euro1: 0,
        Coin.cents50: 0,
        Coin.cents20: 0,
        Coin.cents10: 0,
        Coin.cents5: 0,
        Coin.cents2: 0,
        Coin.cents1: 0,
      };

  /// Creates a Coin Stack wich has a random amount of [0-9] coins per type
  factory CoinStack.random() {
    final Map<Coin, int> coins = {};
    final Random random = Random();
    for (final coinType in Coin.values) {
      coins[coinType] = random.nextInt(10);
    }
    return CoinStack.withCoins(coins);
  }

  /// creates a deep copy of the stack
  CoinStack get fullCopy => CoinStack.withCoins({..._coins});

  /// create a Coin Stack wich already has coins in it
  CoinStack.withCoins(this._coins) {
    for (final coinType in Coin.values) {
      _coins.putIfAbsent(
        coinType,
        () => 0,
      );
    }
  }

  final Map<Coin, int> _coins;

  /// Returns how many coins of the specified type are currently contained
  int getCoinAmount(Coin type) => _coins[type]!;

  /// adds one coin of the specified type to the stack
  ///
  /// The amount must be positive
  void addCoin(Coin type) {
    _coins.update(
      type,
      (value) => value + 1,
    );
  }

  /// reduces the amount of the specidfied coin type by 1
  void removeCoin(Coin type) {
    _coins.update(
      type,
      (value) => max(value - 1, 0),
    );
  }

  /// Returns the biggest coin available in this stack that is worth less or equal the given amount or null, if no such coin is available
  ///
  Coin? getHighestCoinBelowAmount(int amount) {
    for (final coinType in _coins.keys) {
      if ((coinType.worthInCents <= amount) && _coins[coinType]! > 0) {
        return coinType;
      }
    }

    return null;
  }

  /// Checks if the coin stack contains coins that add up exactly to the given amount.
  ///
  /// - If it does, those coins get removed from this stack and returned within a new coin stack.
  ///
  /// If there are multiple possible ways to get to that amount, the one with the least amount of coins is used. For example if the amount is € 2,00 one 2€ coin is preferred over two 1€ coins and so on
  ///
  /// - If not, this is keeps unchanged and null is returned
  ///
  /// ## Example:
  ///
  CoinStack? tryRemoveAmount(int amount) {
    int safetyNet = 1000;
    final CoinStack stackCopy = fullCopy;
    final CoinStack result = CoinStack.empty();

    while (amount >= 0.01 && safetyNet > 0) {
      Coin? nextToTransfer = stackCopy.getHighestCoinBelowAmount(amount);
      if (nextToTransfer == null) {
        return null;
      } else {
        result.addCoin(nextToTransfer);
        stackCopy.removeCoin(nextToTransfer);
        amount -= nextToTransfer.worthInCents;
      }
      safetyNet--;
    }
    _coins.updateAll((key, value) => stackCopy._coins[key]!);
    return result;
  }

  /// get the total value of all coins
  int get sum => _coins.keys.fold(
    0,
    (previousValue, coinType) {
      return previousValue + coinType.worthInCents * _coins[coinType]!;
    },
  );

  String get sumDisplay => MoneyConverter.centsToEutoDisplay(sum);

  @override
  String toString() => _coins.toString();
}
