import 'package:snackautomat_bene_alex/mid_layer/models/coin_stack.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

class SnackMachineInventory {
  final CoinStack coinStorage;
  final List<SnackTMP> snackStorage;
  SnackMachineInventory({
    required this.coinStorage,
    required this.snackStorage,
  });
}
