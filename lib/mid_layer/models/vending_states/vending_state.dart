import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';

abstract class VendingState {
  final int credit;
  final int? selectedSlot;
  final bool acceptsInput;
  VendingState({
    required this.credit,
    required this.acceptsInput,
    this.selectedSlot,
  });

  VendingState onSnackSelected(int slot);
  VendingState onCoinInserted(Coin coin);
  VendingState onReturnPressed();

  String get creditDisplay => MoneyConverter.centsToEutoDisplay(credit);
}
