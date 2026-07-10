import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';

abstract class VendingState {
  final int credit;
  final int? selectedSlot;
  final bool acceptsInput;
  final String displayMessage;
  final bool hasError;
  VendingState({
    required this.credit,
    required this.acceptsInput,
    required this.displayMessage,
    this.selectedSlot,
    this.hasError = false,
  });

  VendingState onSnackSelected(int slot);
  VendingState onCoinInserted(Coin coin);
  VendingState onReturnPressed();

  String get creditDisplay => MoneyConverter.centsToEutoDisplay(credit);
}
