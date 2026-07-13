import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';

part 'snack_slot.freezed.dart';

/// A slot for the vending machine that contains a certain amountof the same snack.
@freezed
class SnackSlot with _$SnackSlot {
  @override
  /// The contained snack's type
  final SnackTMP snack;
  @override
  /// The number of snacks contained in this slot.
  final int amount;

  /// A slot for the vending machine that contains a certain amountof the same snack.

  SnackSlot({required this.snack, required this.amount});

  ///
  String get snackName => snack.name;

  ///
  int get snackPrice => snack.price;

  /// Display String for the snack's price
  String get priceDisplay => MoneyConverter.centsToEutoDisplay(snackPrice);

  /// returns if the slot is empty
  bool get isEmpty => amount <= 0;

  /// returns if the slot is not empty
  bool get isNotEmpty => !isEmpty;
}
