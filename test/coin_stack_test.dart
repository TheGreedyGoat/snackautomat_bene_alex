import 'package:flutter_test/flutter_test.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';

void main() {
  group(
    'CoinStack',
    () {
      test(
        'Adding Coins',
        () {
          final stack = CoinStack.empty();
          for (final coinType in Coin.values) {
            stack.addCoin(coinType);
          }
          expect(stack.sum, equals(200 + 100 + 50 + 20 + 10 + 5 + 2 + 1));
        },
      );
      test(
        'Removing Coins',
        () {
          final stack = CoinStack.withCoins({
            Coin.euro2: 3,
            Coin.euro1: 5,
            Coin.cents20: 3,
          });

          stack.removeCoin(Coin.euro2);
          expect(stack.getCoinAmount(Coin.euro2), equals(2));
        },
      );

      test(
        'Adding another coin map',
        () {
          final stack = CoinStack.withCoins({
            Coin.euro1: 5,
          });

          final copied = stack.copyWithDifference({Coin.euro1: -1});
          expect(
            copied.sum,
            lessThan(stack.sum),

            reason: ' original: ${stack.sum} copied: ${copied.sum}',
          );
        },
      );
      test(
        'Get Change not possible',
        () {
          final stack = CoinStack.withCoins({
            Coin.euro2: 3,
            Coin.euro1: 5,
            Coin.cents20: 3,
            Coin.cents10: 4,
          });

          expect(stack.tryRemoveAmount(241), null);
        },
      );
      test(
        'Get Change not possible',
        () {
          final stack = CoinStack.withCoins({
            Coin.euro2: 3,
            Coin.euro1: 5,
            Coin.cents20: 3,
            Coin.cents10: 4,
          });

          expect(stack.tryRemoveAmount(240), isNotNull);
        },
      );
    },
  );
}
