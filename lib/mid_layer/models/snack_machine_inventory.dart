import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';

part 'snack_machine_inventory.freezed.dart';

@freezed
class SnackMachineInventory with _$SnackMachineInventory {
  final CoinStack coinStorage;
  final CoinStack changeSlot;
  final List<SnackSlot> snackStorage;
  final SnackTMP? ejectedSnack;

  SnackMachineInventory({
    required this.coinStorage,
    required this.snackStorage,
    required this.changeSlot,
    this.ejectedSnack,
  });

  SnackSlot? getSlot(int? index) =>
      (index != null && index < snackStorage.length)
      ? snackStorage[index]
      : null;

  String getNameOfSnack(int? index) => getSlot(index)?.snackName ?? '---';
  int? getPrice(int? index) => getSlot(index)?.price;
  int? getAmount(int? index) => getSlot(index)?.amount;
}
