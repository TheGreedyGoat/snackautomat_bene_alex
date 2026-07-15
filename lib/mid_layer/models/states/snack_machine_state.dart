import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

part 'snack_machine_state.freezed.dart';

/// The overall State of the machine, including inventory and vending state
@freezed
class SnackMachineState with _$SnackMachineState {
  @override
  /// Represents the coins in the machine's safe
  final CoinStack coinStorage;
  @override
  /// represents the coins in the returning slot
  final CoinStack changeSlot;
  @override
  /// The machine's slots wich contain the snacks the user can select
  final List<SnackStack> snackStorage;
  @override
  /// The slot where a paid snack is dispensed to
  final Snack? ejectedSnack;
  @override
  /// The machine's current vending state
  final VendingState vendingState;

  NumberPadState get numberPadState => vendingState.numberPadState;

  /// The overall State of the machine, including inventory and vending state
  SnackMachineState({
    required this.coinStorage,
    required this.changeSlot,
    required this.snackStorage,
    this.ejectedSnack,
    required this.vendingState,
  });

  /// returns a copy of this with one coin of the given [coinType] added
  SnackMachineState insertCoin(Coin coinType) {
    return copyWith(coinStorage: coinStorage.copyWithDifference({coinType: 1}));
  }

  /// Returns the slot with the given index if existing
  SnackStack? getSlot(int? index) =>
      index == null || index >= snackStorage.length
      ? null
      : snackStorage[index];

  /// returns true if the slotindex exists and the slot is not empty, false else
  bool snackAvailable(int? index) {
    final slot = getSlot(index);
    return slot != null && slot.isNotEmpty;
  }
}
