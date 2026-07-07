import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/coin_stack_notifier.dart';

void main() {
  final ref = ProviderContainer();
  final coinStackTestProvider = NotifierProvider(
    () => CoinStackNotifier(),
  );

  group(
    'Riverpod test',
    () {
      const example = {
        Coin.euro2: 8,
        Coin.euro1: 7,
        Coin.cents50: 6,
        Coin.cents20: 5,
        Coin.cents10: 4,
        Coin.cents5: 3,
        Coin.cents2: 2,
        Coin.cents1: 1,
      };
      test(
        'Assinging values',
        () {
          ref.read(coinStackTestProvider.notifier).setStack({...example});
          final read = ref.read(coinStackTestProvider).coins;
          expect(read, equals(example), reason: '$example\n$read');
        },
      );

      test(
        'Add Coin',
        () {
          for (final coin in Coin.values) {
            ref.read(coinStackTestProvider.notifier).setStack({...example});
            final oldAmount = ref
                .read(coinStackTestProvider)
                .getCoinAmount(coin);
            final int toAdd = 5;
            for (int i = 0; i < toAdd; i++) {
              ref.read(coinStackTestProvider.notifier).addCoin(coin);
            }

            final result = ref.read(coinStackTestProvider);
            final newAmount = result.getCoinAmount(coin);
            expect(
              newAmount,
              equals(oldAmount + toAdd),
              reason:
                  'amount of $coin-coins is $newAmount but should be should be ${oldAmount + toAdd}',
            );
          }
        },
      );
    },
  );
}
