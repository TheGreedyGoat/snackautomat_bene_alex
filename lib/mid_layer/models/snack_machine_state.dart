import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';

part 'snack_machine_state.freezed.dart';

@freezed
class SnackMachineState with _$SnackMachineState {
  final CoinStack coinStorage;
  final CoinStack changeSlot;
  final List<SnackSlot> snackStorage;
  final SnackTMP? ejectedSnack;

  final VendingState vendingState;
  SnackMachineState({
    required this.coinStorage,
    required this.changeSlot,
    required this.snackStorage,
    this.ejectedSnack,
    required this.vendingState,
  });

  SnackMachineState insertCoin(Coin coinType) {
    return copyWith(coinStorage: coinStorage.copyWithDifference({coinType: 1}));
  }

  SnackSlot? getSlot(int? index) =>
      index == null || index >= snackStorage.length
      ? null
      : snackStorage[index];

  bool snackAvailable(int? index) {
    final slot = getSlot(index);
    return slot != null && slot.isNotEmpty;
  }
}
