import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/back_layer/database_service.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/snack_machine_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/error_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/pay_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

//TODO: Switch to Fallout items
final snacks = [
  const Snack(
    name: 'Twix',
    price: 120,
    image: 'assets/images/Twix.png',
  ),
  const Snack(
    name: 'Rafaelo',
    price: 223,
    image: 'assets/images/Rafaelo.png',
  ),
  const Snack(
    name: 'Pringles',
    price: 300,
    image: 'assets/images/Pringles.png',
  ),
  const Snack(
    name: 'Milka Oreo',
    price: 300,
    image: 'assets/images/MilkaOreo.png',
  ),
];

/// The core logical unit of the state machine.
///
/// Manages all the communication about the snack machine's inventory and current vending state
class SnackMachineNotifier extends AsyncNotifier<SnackMachineState> {
  static const int _coinStorageID = 0;
  static const int _coinChangeID = 1;
  DataBaseService get _dbService => DataBaseService.instance;

  late final List<void Function()?> dispenseAnimationCallbacks;

  @override
  Future<SnackMachineState> build() async {
    await _dbService.showSnackStacks();
    var coinStorage = await _dbService.getCoinStack(_coinStorageID, true);
    print(coinStorage);
    var change = await _dbService.getCoinStack(_coinChangeID, true);
    var snackStorage = await _dbService.getSnackStacks();
    if (snackStorage.isEmpty) {
      for (int i = 0; i < snacks.length; i++) {
        await _dbService.insertSnackStack(SnackStack(snackID: i, count: 5));
      }
    }
    dispenseAnimationCallbacks = snackStorage
        .map(
          (_) => _defaultAutoTimer,
        )
        .toList(growable: false);
    var vendingState = await _dbService.vendingState;
    if (!coinStorage.canReturnAmount(vendingState.credit)) {
      vendingState = IdleState(numberPadState: NumberPadState.init());
    }
    return SnackMachineState(
      coinStorage: coinStorage,
      changeSlot: change,
      snackStorage: snackStorage,
      vendingState: vendingState,
    );
  }

  void setDispenseCallBack(int index, void Function() cb) {
    if (index < 0 || index >= dispenseAnimationCallbacks.length) return;
    dispenseAnimationCallbacks[index] = cb;
  }

  SnackMachineState? tryFetchState() {
    SnackMachineState? maybeState;
    state.whenData(
      (value) => maybeState = value,
    );
    return maybeState!;
  }

  // 8b           d8  88888888888  888b      88  88888888ba,
  // `8b         d8'  88           8888b     88  88      `"8b
  //  `8b       d8'   88           88 `8b    88  88        `8b
  //   `8b     d8'    88aaaaa      88  `8b   88  88         88
  //    `8b   d8'     88"""""      88   `8b  88  88         88
  //     `8b d8'      88           88    `8b 88  88         8P
  //      `888'       88           88     `8888  88      .a8P
  //       `8'        88888888888  88      `888  88888888Y"'

  set coinStorage(CoinStack newStorage) {
    _dbService
        .updateCoinstack(newStorage, _coinStorageID)
        .then(
          (_) => state = state.whenData(
            (state) => state.copyWith(coinStorage: newStorage),
          ),
        );
  }

  set changeSlot(CoinStack newStorage) {
    _dbService
        .updateCoinstack(newStorage, _coinChangeID)
        .then(
          (_) => state = state.whenData(
            (state) => state.copyWith(changeSlot: newStorage),
          ),
        );
  }

  void _defaultAutoTimer() {
    Future.delayed(Duration(seconds: 3)).then(
      (_) => onFinished(),
    );
  }

  /// A shortcut to the vending-substate.
  ///
  /// Setting this also updates the overall state
  VendingState get vendingState {
    VendingState? result;
    int credit = 0;
    state.whenData(
      (state) {
        result = state.vendingState;
        credit = state.vendingState.credit;
      },
    );
    return result ?? ErrorState(credit: credit, numberPadState: numberPadState);
  }

  set vendingState(VendingState newState) {
    if (newState is DispenseSnackState) {
      final value = newState.selectedSlot;
      state.whenData(
        (state) {
          if (state.getSlot(value)!.isEmpty) {
            newState = NoSelectionState(
              credit: newState.credit,
              numberPadState: numberPadState,
            );
          }
        },
      );
    }
    _dbService.updateVendingState(newState).then(
      (_) {
        state = state.whenData(
          (value) => value.copyWith(vendingState: newState),
        );
        _resetTimer?.cancel();

        if (vendingState is ManualState &&
            vendingState is! IdleState &&
            vendingState is! ErrorState) {
          _resetTimer = Timer(
            Duration(seconds: 5),
            _reset,
          );
        } else if (vendingState is ReturnCoinsState) {
          _defaultAutoTimer();
        } else if (vendingState is DispenseSnackState) {
          dispenseAnimationCallbacks[vendingState.selectedSlot!]?.call();
        }
        if (vendingState is ManualState) {
          _checkPaidAndDispense();
        }
      },
    );
  }

  // {
  //   vending_type: NoSelectionState,
  //   vending_slot: null,
  //   vending_credit: 200
  // }
  /* 
  ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: SqfliteFfiException(sqlite_error: 1, , SqliteException(1): while preparing statement, near ",": syntax error, SQL logic error (code 1)
  Causing statement (at position 103): UPDATE VENDINGSTATES SET vending_type = ?, vending_slot = NULL, vending_credit = ? WHERE vending_id = ?,})
  */
  Timer? _resetTimer;

  void _checkPaidAndDispense() {
    int? snackIndex = vendingState.selectedSlot;
    int? price;

    state.whenData(
      (value) => price = value.getSlot(snackIndex)?.snackPrice,
    );
    if (price == null || vendingState.credit < price!) return;
    // price != null => snack is selected!
    if (checkForChange(
          vendingState.credit - price!,
        ) !=
        null) {
      // Rückgeld möglich, Ausgabe
      vendingState = DispenseSnackState(
        credit: vendingState.credit - price!,
        selectedSlot: vendingState.selectedSlot,
      );
    } else {
      // Rückgeld nicht möglich, Auswahl aufheben
      vendingState = NoSelectionState(
        credit: vendingState.credit,
        displayMessage: 'Rückgeld nicht möglich',
        hasError: true,
        numberPadState: NumberPadState.init(),
      );
    }
  }

  // 88888888888
  // 88                                              ,d
  // 88                                              88
  // 88aaaaa  8b       d8   ,adPPYba,  8b,dPPYba,  MM88MMM  ,adPPYba,
  // 88"""""  `8b     d8'  a8P_____88  88P'   `"8a   88     I8[    ""
  // 88        `8b   d8'   8PP"""""""  88       88   88      `"Y8ba,
  // 88         `8b,d8'    "8b,   ,aa  88       88   88,    aa    ]8I
  // 88888888888  "8"       `"Ybbd8"'  88       88   "Y888  `"YbbdP"'

  /// call, when the user inserts a coin into the machine
  void onCoinInserted(Coin coin) {
    if (!vendingState.acceptsInput) return;
    //  CoinStack? storage;
    vendingState = vendingState.onCoinInserted(coin);
    state = state.whenData(
      (value) {
        final newState = value.insertCoin(coin);
        coinStorage = newState.coinStorage;
        return newState;
      },
    );
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
    vendingState = vendingState.onReturnPressed();
    // vendingState = IdleState(numberPadState: NumberPadState.init());
  }

  void _deselectSnack() {
    vendingState = NoSelectionState(
      credit: vendingState.credit,
      numberPadState: NumberPadState.init(),
    );
  }

  // 888b      88
  // 8888b     88
  // 88 `8b    88
  // 88  `8b   88  88       88  88,dPYba,,adPYba,
  // 88   `8b  88  88       88  88P'   "88"    "8a
  // 88    `8b 88  88       88  88      88      88
  // 88     `8888  "8a,   ,a88  88      88      88
  // 88      `888   `"YbbdP'Y8  88      88      88
  /// Stores the current digits entered via the number pad
  NumberPadState get numberPadState => vendingState.numberPadState;

  set numberPadState(NumberPadState newState) {
    vendingState = vendingState.setNumPadState(newState);
  }

  /// call if the user inputs a digit via the Number pad
  void inputDigit(int digit) {
    if (!vendingState.acceptsInput) return;
    final currentNumState = numberPadState;
    final newNumPadState = currentNumState.input(digit);
    VendingState newState = vendingState.setNumPadState(newNumPadState);
    state.whenData(
      (state) {
        if (newNumPadState.value == null) return;
        final slot = state.getSlot(newNumPadState.value);
        if (slot == null || slot.isEmpty) {
          newState = newState = NoSelectionState(
            credit: newState.credit,
            numberPadState: NumberPadState.init(),
            displayMessage: slot == null
                ? 'Fach existiert nicht!'
                : 'Fach ist leer :(',
          );
        }
      },
    );
    vendingState = newState;
  }

  /// call to reset the Number pad (sets all digits to null)
  void clearNumPad() {
    _deselectSnack();
    numberPadState = NumberPadState.init();
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
    final maybeState = tryFetchState();
    if (maybeState == null) return null;

    final actualState = maybeState;
    final storage = actualState.coinStorage.fullCopy;
    final change = actualState.changeSlot.fullCopy;
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
      state.whenData((value) {
        coinStorage = value.coinStorage.copyWithDifference(
          change.coinsNegative,
        );
        changeSlot = change;
        vendingState = IdleState(numberPadState: NumberPadState.init());
      });
    }
    return success;
  }

  /// the machine dispenses the snack at [index]
  void dispenseSnack(int index) {
    final maybeState = tryFetchState();
    if (maybeState == null) return;

    var stack = maybeState.getSlot(index);
    assert(
      stack != null,
      'Error while dispensing snack: SnackSlot with index $index not found!',
    );
    stack = stack!;

    if (!maybeState.snackAvailable(index)) return;
    _dbService.updateSnackStack(index, stack.count - 1).then(
      (_) {
        final storage = maybeState.snackStorage.toList();

        storage[index] = stack!.copyWith(count: stack.count - 1);
        state = AsyncData(
          maybeState.copyWith(
            snackStorage: storage,
            ejectedSnackIndex: stack.snackID,
          ),
        );
      },
    );
  }

  /// removes all the coins in the change slot and returns it
  CoinStack emptyChange() {
    final maybeState = tryFetchState();
    if (maybeState == null) return CoinStack.empty();
    CoinStack change = maybeState.changeSlot;
    changeSlot = CoinStack.empty();
    return change;
  }

  /// removes the snack thats currently in the ejection slot and returns it.
  Snack? emptyDispenseSlot() {
    final maybeState = tryFetchState();
    if (maybeState == null) return null;

    Snack? snack = maybeState.ejectedSnack;
    state = AsyncData(maybeState.copyWith(ejectedSnackIndex: null));
    return snack;
  }

  void refillSnacks() {
    for (int i = 0; i < snacks.length; i++) {
      _dbService.updateSnackStack(i, 5);
    }
    _dbService.getSnackStacks().then(
      (stacks) {
        state = state.whenData(
          (state) {
            return state.copyWith(snackStorage: stacks);
          },
        );
      },
    );
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
