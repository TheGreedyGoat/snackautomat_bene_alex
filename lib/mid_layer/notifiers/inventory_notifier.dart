import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_machine_inventory.dart';

const List<SnackTMP> exampleSnacks = [
  SnackTMP(name: 'Nuka Cola', price: 250),
  SnackTMP(name: 'Nuka Cola Quantum', price: 450),
  SnackTMP(name: 'Rad Away', price: 430),
  SnackTMP(name: 'Stimpack', price: 630),
  SnackTMP(name: 'Jet', price: 500),
  SnackTMP(name: 'Buffout', price: 500),
  SnackTMP(name: 'Mentats', price: 500),
  SnackTMP(name: 'Med-x', price: 500),
  SnackTMP(name: 'Psycho', price: 500),
];

class InventoryNotifier extends AsyncNotifier<SnackMachineInventory> {
  @override
  FutureOr<SnackMachineInventory> build() => SnackMachineInventory(
    coinStorage: CoinStack.random(),
    changeSlot: CoinStack.empty(),
    snackStorage: exampleSnacks
        .map(
          (e) => e.createSlot(10),
        )
        .toList(),
  );

  void insertCoin(Coin coin) {
    state = state.whenData(
      (state) {
        final stack = state.coinStorage;
        return state.copyWith(coinStorage: stack.copyWithDifference({coin: 1}));
      },
    );
  }

  CoinStack? checkForChange(int amount) {
    CoinStack? chng;
    state.whenData(
      (value) {
        final storage = value.coinStorage.fullCopy;
        final change = value.changeSlot.fullCopy;
        while (amount >= 0.01) {
          Coin? nextToRemove = storage.tryGetHighestCoinBelowAmount(amount);
          if (nextToRemove == null) {
            return;
          } else {
            assert(
              storage.tryTransferCoin(nextToRemove, change),
              _failedTransferErrorMessage(nextToRemove, storage, change),
            );
            amount -= nextToRemove.worth;
          }
        }
        chng = change;
      },
    );
    return chng;
  }

  bool tryGetChange(int amount) {
    final change = checkForChange(amount);
    final success = change != null;
    if (success) {
      state = state.whenData(
        (value) => value.copyWith(changeSlot: change),
      );
    }
    return success;
  }

  void dispenseSnack(int index) {
    state = state.whenData(
      (value) {
        final slot = value.getSlot(index);
        assert(
          slot != null,
          'Error while dispensing snack: SnackSlot with index $index not found!',
        );

        if (slot!.isEmpty) return value;
        final storage = value.snackStorage.toList();

        storage[index] = slot.copyWith(amount: slot.amount - 1);
        return value.copyWith(snackStorage: storage, ejectedSnack: slot.snack);
      },
    );
  }

  CoinStack emptyChange() {
    CoinStack? change;
    state = state.whenData(
      (inv) {
        change = inv.changeSlot;
        return inv.copyWith(changeSlot: CoinStack.empty());
      },
    );
    return change ?? CoinStack.empty();
  }

  SnackTMP? emptyDispenseSlot() {
    SnackTMP? snack;
    state = state.whenData(
      (value) {
        snack = value.ejectedSnack;
        return value.copyWith(ejectedSnack: null);
      },
    );
    return snack;
  }

  static String _failedTransferErrorMessage(
    Coin? nextToRemove,
    CoinStack storage,
    CoinStack change,
  ) =>
      '''
===ERROR in InventoryNotifier.tryGetChange:===\n
Coin $nextToRemove could not be transferred to change stack.\n
Storage:\n
$storage
Change: \n
$change
''';
}
