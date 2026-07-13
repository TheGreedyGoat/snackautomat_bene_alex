import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_machine_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

const List<SnackTMP> _exampleSnacks = [
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

/// The core logical unit of the state machine.
///
/// MAnages all the communication about the snack machine's inventory and current vending state
class SnackMachineNotifier extends Notifier<SnackMachineState> {
  @override
  SnackMachineState build() => SnackMachineState(
    coinStorage: CoinStack.withCoins(
      {for (final c in Coin.values) c: 10},
    ),
    changeSlot: CoinStack.empty(),
    snackStorage: _exampleSnacks
        .map(
          (e) => SnackSlot(snack: e, amount: 3),
        )
        .toList(),
    vendingState: IdleState(),
  );

  // 8b           d8  88888888888  888b      88  88888888ba,
  // `8b         d8'  88           8888b     88  88      `"8b
  //  `8b       d8'   88           88 `8b    88  88        `8b
  //   `8b     d8'    88aaaaa      88  `8b   88  88         88
  //    `8b   d8'     88"""""      88   `8b  88  88         88
  //     `8b d8'      88           88    `8b 88  88         8P
  //      `888'       88           88     `8888  88      .a8P
  //       `8'        88888888888  88      `888  88888888Y"'

  /// A shortcut to the vending-substate.
  ///
  /// Setting this also updates the overall state
  VendingState get vendingState => state.vendingState;

  set vendingState(VendingState newState) {
    state = state.copyWith(vendingState: newState);
    _resetTimer?.cancel();

    if (vendingState is ManualState && vendingState is! IdleState) {
      _resetTimer = Timer(
        Duration(seconds: 500),
        _reset,
      );
    } else if (vendingState is AutoState) {
      Future.delayed(Duration(seconds: 3)).then(
        (_) => onFinished(),
      );
    }
  }

  @override
  set state(SnackMachineState newState) {
    super.state = newState;
  }

  Timer? _resetTimer;

  void _checkPaidAndDispense() {
    int? snackIndex = vendingState.selectedSlot;
    int? price = state.getSlot(snackIndex)?.snackPrice;
    print(' checkPaid\nprice: $price\n credit: ${vendingState.credit}');
    if (price == null || vendingState.credit < price) return;

    if (checkForChange(
          vendingState.credit - price,
        ) !=
        null) {
      vendingState = DispenseSnackState(
        credit: vendingState.credit - price,
        selectedSlot: vendingState.selectedSlot,
      );
    } else {
      vendingState = NoSelectionState(
        credit: vendingState.credit,
        displayMessage: 'Rückgeld nicht möglich',
        hasError: true,
      );
    }
  }

  /// call, when the user selects a snack
  void onSlotSelected(int slot) {
    if (!vendingState.acceptsInput) return;
    if (state.snackAvailable(slot)) {
      vendingState = vendingState.onSnackSelected(slot);
      _checkPaidAndDispense();
    } else {
      vendingState = NoSelectionState(
        credit: vendingState.credit,
        displayMessage: 'Fach ist leer, Wählen Sie etwas anderes',
        hasError: true,
      );
    }
  }

  /// call, when the user inserts a coin into the machine
  void onCoinInserted(Coin coin) {
    if (!vendingState.acceptsInput) return;
    vendingState = vendingState.onCoinInserted(coin);
    state = state.insertCoin(coin);
    _checkPaidAndDispense();
  }

  /// call, when the user prsses the snack machine's return button
  void onReturnPressed() {
    if (!vendingState.acceptsInput) return;
    vendingState = vendingState.onReturnPressed();
  }

  /// call, when an event occured that triggers
  void onFinished() {
    if (vendingState is AutoState) {
      final aState = vendingState as AutoState;
      aState.updateNotifier(this);
      vendingState = aState.onFinished();
    }
  }

  void _reset() {
    tryDispenseChange();
    vendingState = IdleState();
  }

  // 88  888b      88  8b           d8
  // 88  8888b     88  `8b         d8'
  // 88  88 `8b    88   `8b       d8'
  // 88  88  `8b   88    `8b     d8'
  // 88  88   `8b  88     `8b   d8'
  // 88  88    `8b 88      `8b d8'
  // 88  88     `8888       `888'
  // 88  88      `888        `8'
  /// Checks if the machine can currently dispense the given [amount]
  ///
  /// and returns the resulting CoinStack if it can
  CoinStack? checkForChange(int amount) {
    final storage = state.coinStorage.fullCopy;
    final change = state.changeSlot.fullCopy;
    while (amount > 0) {
      Coin? nextToRemove = storage.tryGetHighestCoinBelowAmount(amount);
      if (nextToRemove == null) {
        return null;
      } else {
        assert(
          storage.tryTransferCoin(nextToRemove, change),
          _failedTransferErrorMessage(nextToRemove, storage, change),
        );
        amount -= nextToRemove.worth;
      }
    }
    return change;
  }

  /// Tries dispensing the [vendingState]'s current credit as coins and returns if it succeded
  bool tryDispenseChange() {
    final change = checkForChange(vendingState.credit);
    final success = change != null;
    if (success) {
      state = state.copyWith(
        coinStorage: state.coinStorage.copyWithDifference(change.coinsNegative),
        vendingState: IdleState(),
        changeSlot: change,
      );
    }
    return success;
  }

  /// the machine dispenses the snack at [index]
  void dispenseSnack(int index) {
    print('dispensing snack $index');
    var slot = state.getSlot(index);
    assert(
      slot != null,
      'Error while dispensing snack: SnackSlot with index $index not found!',
    );
    slot = slot!;

    if (!state.snackAvailable(index)) return;
    final storage = state.snackStorage.toList();

    storage[index] = slot.copyWith(amount: slot.amount - 1);
    state = state.copyWith(snackStorage: storage, ejectedSnack: slot.snack);
  }

  /// removes all the coins in the change slot and returns it
  CoinStack emptyChange() {
    CoinStack change = state.changeSlot;
    state = state.copyWith(changeSlot: CoinStack.empty());
    return change;
  }

  /// removes the snack thats currently in the ejection slot and returns it.
  SnackTMP? emptyDispenseSlot() {
    SnackTMP? snack = state.ejectedSnack;
    state = state.copyWith(ejectedSnack: null);
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
