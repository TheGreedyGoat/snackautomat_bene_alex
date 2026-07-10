import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';

part 'snack_slot.freezed.dart';

@freezed
class SnackSlot with _$SnackSlot {
  final SnackTMP snack;
  final int amount;
  SnackSlot({required this.snack, required this.amount});

  String get snackName => snack.name;
  int get price => snack.price;
  String get priceDisplay => MoneyConverter.centsToEutoDisplay(price);

  bool get isEmpty => amount <= 0;
  bool get isNotEmpty => !isEmpty;
}
