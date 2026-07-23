import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/back_layer/database_service.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/snack_machine_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/automatic/return_coins_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/error_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

final snacks = [
  const Snack(
    name: 'Nuka Cola',
    price: 120,
    image: 'assets/images/nuka_classic.png',
  ),
  const Snack(
    name: 'Nuka Cola Dark',
    price: 120,
    image: 'assets/images/nuka_dark.png',
  ),
  const Snack(
    name: 'Nuka Cola Orange',
    price: 120,
    image: 'assets/images/nuka_orange.png',
  ),
  const Snack(
    name: 'Nuka Cola Quantum',
    price: 223,
    image: 'assets/images/nuka_quantum.png',
  ),
  const Snack(
    name: 'Nuka Cherry',
    price: 120,
    image: 'assets/images/nuka_cherry.png',
  ),
  const Snack(
    name: 'Rad Away',
    price: 300,
    image: 'assets/images/rad_away.png',
  ),
  const Snack(
    name: 'BlamCo Mac & Cheese',
    price: 300,
    image: 'assets/images/blamco.png',
  ),
  const Snack(
    name: 'Cram',
    price: 300,
    image: 'assets/images/cram.png',
  ),
  const Snack(
    name: 'Sugar Bombs',
    price: 300,
    image: 'assets/images/sugar_bombs.png',
  ),
];

/// Placeholder snacks: 16 slots for the 4x4 grid,
/// the 4 types just repeat until all slots are filled
// final snacks = [
//   for (int i = 0; i < 16; i++) _snackTypes[i % _snackTypes.length],
// ];

/// The core logical unit of the state machine.
///
/// Manages all the communication about the snack machine's inventory and current vending state
class SnackMachineNotifier extends AsyncNotifier<SnackMachineState> {
  static const int _coinStorageID = 0;
  static const int _coinChangeID = 1;
  DataBaseService get _dbService => DataBaseService.instance;

  late final List<Future<void> Function()> _dispenseAnimationCallbacks;
  bool _animationRunning = false;

  @override
  Future<SnackMachineState> build() async {
    final coinStorage = await _dbService.coinStorage;
    final change = await _dbService.coinChange;
    final snackStorage = await _dbService.snackStacks;
    final vendingState = await _dbService.vendingState;
    _dispenseAnimationCallbacks = [
      for (int i = 0; i < snackSlotCount; i++) _defaultAutoTimer,
    ];
    return SnackMachineState(
      coinStorage: coinStorage,
      changeSlot: change,
      snackStorage: snackStorage,
      vendingState: vendingState,
    );
  }
  //                          .       .    o8o
  //                      .o8     .o8    `"'
  //  .oooo.o  .ooooo.  .o888oo .o888oo oooo  ooo. .oo.    .oooooooo  .oooo.o
  // d88(  "8 d88' `88b   888     888   `888  `888P"Y88b  888' `88b  d88(  "8
  // `"Y88b.  888ooo888   888     888    888   888   888  888   888  `"Y88b.
  // o.  )88b 888    .o   888 .   888 .  888   888   888  `88bod8P'  o.  )88b
  // 8""888P' `Y8bod8P'   "888"   "888" o888o o888o o888o `8oooooo.  8""888P'
  //                                                      d"     YD
  //                                                      "Y88888P'

  static const _autoResetTimerDuration = 30;

  /// set the callback for when the machine enters the [DispenseSnackState] to dispense the snack within the slot of the passed id.
  ///
  /// Use to start the dispensing process in the UI (eg animations etc.)
  ///
  /// The notifier will then wait for the returned Future to resolve to go to the next state
  void setDispenseCallBack(int slotID, Future<void> Function() cb) {
    if (slotID < 0 || slotID >= _dispenseAnimationCallbacks.length) return;
    _dispenseAnimationCallbacks[slotID] = () async {
      _animationRunning = true;
      await cb();
    };
  }

  SnackMachineState? _tryFetchState() {
    SnackMachineState? maybeState;
    state.whenData(
      (value) => maybeState = value,
    );
    return maybeState!;
  }

  @override
  set state(newState) {
    _resetTimer?.cancel();

    state.whenData(
      (value) {},
    );
    newState.whenData(
      (value) {
        if (value.vendingState is ManualState &&
            (value.vendingState as ManualState).autoReset) {
          _resetTimer = Timer(
            Duration(seconds: _autoResetTimerDuration),
            _reset,
          );
        }
        if (value.vendingState is DispenseSnackState && !_animationRunning) {
          _dispenseAnimationCallbacks[value.vendingState.selectedSlot!]().then(
            (_) {
              onFinished();
              _animationRunning = false;
            },
          );
        }
      },
    );
    super.state = newState;
  }

  // 8b           d8  88888888888  888b      88  88888888ba,
  // `8b         d8'  88           8888b     88  88      `"8b
  //  `8b       d8'   88           88 `8b    88  88        `8b
  //   `8b     d8'    88aaaaa      88  `8b   88  88         88
  //    `8b   d8'     88"""""      88   `8b  88  88         88
  //     `8b d8'      88           88    `8b 88  88         8P
  //      `888'       88           88     `8888  88      .a8P
  //       `8'        88888888888  88      `888  88888888Y"'

  set _coinStorage(CoinStack newStorage) {
    _dbService
        .updateCoinstack(newStorage, _coinStorageID)
        .then(
          (_) => state = state.whenData(
            (state) => state.copyWith(coinStorage: newStorage),
          ),
        );
  }

  set _changeSlot(CoinStack newStorage) {
    _dbService
        .updateCoinstack(newStorage, _coinChangeID)
        .then(
          (_) => state = state.whenData(
            (state) => state.copyWith(changeSlot: newStorage),
          ),
        );
  }

  Future<void> _defaultAutoTimer() async {
    await Future.delayed(Duration(seconds: 3));
  }

  /// A shortcut to the vending-substate.
  ///
  /// Setting this also updates the overall state
  VendingState get _vendingState {
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

  set _vendingState(VendingState newState) {
    _resetTimer?.cancel();

    if (newState is ReturnCoinsState) {
      _defaultAutoTimer().then(
        (_) => onFinished(),
      );
    }
    state = state.whenData(
      (value) => value.copyWith(vendingState: newState),
    );
    _dbService.updateVendingState(newState);
  }

  Timer? _resetTimer;

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
    if (!_vendingState.acceptsInput) return;
    //  CoinStack? storage;
    VendingState newVendingState = _vendingState.onCoinInserted(coin);

    state = state.whenData(
      (state) {
        final newState = state
            .insertCoin(coin)
            .copyWith(vendingState: newVendingState);
        final slotID = _vendingState.selectedSlot;

        if (slotID != null && newState.canDispenseSnack(slotID)) {
          newVendingState = DispenseSnackState(
            credit: newVendingState.credit - state.getSlot(slotID)!.snackPrice,
            selectedSlot: slotID,
          );
        }
        return newState.copyWith(vendingState: newVendingState);
      },
    );
    // _checkPaidAndDispense();
  }

  /// call, when the user prsses the snack machine's return button
  void onReturnPressed() {
    if (!_vendingState.acceptsInput) return;
    _vendingState = _vendingState.onReturnPressed();
  }

  /// call, when an event occured that triggers
  void onFinished() {
    if (_vendingState is AutoState) {
      final aState = _vendingState as AutoState;
      aState.updateNotifier(this);
      _vendingState = aState.onFinished();
    }
  }

  void _reset() {
    _vendingState = _vendingState.onReturnPressed();
  }

  void _deselectSnack() {
    _vendingState = NoSelectionState(
      credit: _vendingState.credit,
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
  NumberPadState get numberPadState => _vendingState.numberPadState;

  set numberPadState(NumberPadState newState) {
    _vendingState = _vendingState.setNumPadState(newState);
  }

  /// call if the user inputs a digit via the Number pad
  void inputDigit(int digit) {
    if (!_vendingState.acceptsInput) return;
    final currentNumState = numberPadState;
    final newNumPadState = currentNumState.input(digit);

    VendingState newVendingState = _vendingState.setNumPadState(newNumPadState);
    state.whenData(
      (state) {
        if (newNumPadState.value == null) return;

        final slot = state.getSlot(newNumPadState.value);

        if (slot == null || slot.isEmpty) {
          newVendingState = newVendingState = NoSelectionState(
            credit: newVendingState.credit,
            numberPadState: NumberPadState.init(),
            displayMessage: slot == null
                ? 'Fach existiert nicht!'
                : 'Fach ist leer :(',
          );
          return;
        }

        final nextState = state.copyWith(vendingState: newVendingState);
        if (nextState.canDispenseSnack(slot.id)) {
          newVendingState = DispenseSnackState(
            credit: newVendingState.credit - slot.snackPrice,
            selectedSlot: slot.id,
          );
        } else {}
      },
    );
    _vendingState = newVendingState;
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
    final maybeState = _tryFetchState();
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

  /// Tries dispensing the [_vendingState]'s current credit as coins and returns if it succeded
  bool tryDispenseChange() {
    final change = checkForChange(_vendingState.credit);
    final success = change != null;
    if (success) {
      state.whenData((value) {
        _coinStorage = value.coinStorage.copyWithDifference(
          change.coinsNegative,
        );
        _changeSlot = change;
        _vendingState = IdleState(numberPadState: NumberPadState.init());
      });
    }
    return success;
  }

  /// the machine dispenses the snack at [slotID]
  void dispenseSnack(int slotID) {
    final maybeState = _tryFetchState();
    if (maybeState == null) return;

    var stack = maybeState.getSlot(slotID);
    assert(
      stack != null,
      'Error while dispensing snack: SnackSlot with index $slotID not found!',
    );
    stack = stack!;

    if (!maybeState.snackAvailable(slotID)) return;

    final storage = maybeState.snackStorage.toList();

    storage[slotID] = stack.copyWith(count: stack.count - 1);
    state = AsyncData(
      maybeState.copyWith(
        snackStorage: storage,
        ejectedSnackIndex: stack.snackIndex,
        // vendingState: (_vendingState as DispenseSnackState).onFinished()
      ),
    );
    _dbService.updateSnackStackCount(slotID, stack.count - 1);
  }

  /// removes all the coins in the change slot and returns it
  CoinStack emptyChange() {
    final maybeState = _tryFetchState();
    if (maybeState == null) return CoinStack.empty();
    CoinStack change = maybeState.changeSlot;
    _changeSlot = CoinStack.empty();
    return change;
  }

  /// removes the snack thats currently in the ejection slot and returns it.
  Snack? emptyDispenseSlot() {
    final maybeState = _tryFetchState();
    if (maybeState == null) return null;

    Snack? snack = maybeState.ejectedSnack;
    state = AsyncData(maybeState.copyWith(ejectedSnackIndex: null));
    return snack;
  }

  /// sets all snack stacks back to contain 5 snacks, minimum of 1
  void refillSnacks([int count = 5]) {
    state.whenData(
      (st) async {
        final notEmpty = st.snackStorage.where(
          (element) => element.snackIndex != null,
        );
        for (final slot in notEmpty) {
          await _dbService.updateSnackStackCount(
            slot.snackIndex!,
            max(count, 1),
          );
        }
        final stacks = await _dbService.snackStacks;

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

  //                 .o8                     o8o
  //                "888                     `"'
  //  .oooo.    .oooo888  ooo. .oo.  .oo.   oooo  ooo. .oo.
  // `P  )88b  d88' `888  `888P"Y88bP"Y88b  `888  `888P"Y88b
  //  .oP"888  888   888   888   888   888   888   888   888
  // d8(  888  888   888   888   888   888   888   888   888
  // `Y888""8o `Y8bod88P" o888o o888o o888o o888o o888o o888o

  void setSnackSlot(int slotID, int snackIndex) {
    if (slotID < 0 ||
        slotID >= snackSlotCount ||
        snackIndex < 0 ||
        snackIndex >= snacks.length) {
      return;
    }
    _dbService.changeSnackStack(slotID, snackIndex, 5).then(
      (success) {
        if (success) {
          final fState = _tryFetchState();
          assert(fState != null);
          final slots = fState!.snackStorage.toList();
          final s = slots[slotID];

          slots[slotID] = s.copyWith(count: 5, snackIndex: snackIndex);

          state = state.whenData(
            (value) {
              return value.copyWith(
                snackStorage: slots,
              );
            },
          );
        }
      },
    );
  }
}
