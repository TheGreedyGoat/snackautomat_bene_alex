import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

part 'snack_stack.freezed.dart';

/// A slot for the vending machine that contains a certain amountof the same snack.
@freezed
class SnackStack with _$SnackStack {
  @override
  final int id;

  /// The index of the contained snack within the [snacks] list
  @override
  final int? snackIndex;
  @override
  /// The number of snacks contained in this slot.
  final int count;

  /// A slot for the vending machine that contains a certain amountof the same snack.
  SnackStack({
    required this.snackIndex,
    required this.count,
    required this.id,
  });

  /// The contained snack's type
  Snack? get snack => snackIndex != null ? snacks[snackIndex!] : null;

  ///
  String? get snackName => snack?.name ?? 'LEER';

  ///
  int get snackPrice => snack?.price ?? -1;

  /// Display String for the snack's price
  String get priceDisplay => MoneyConverter.centsToEutoDisplay(snackPrice);

  /// returns if the slot is empty
  bool get isEmpty => snackIndex == null || count <= 0;

  /// returns if the slot is not empty
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() =>
      '{Snack stack $id, snackIndex: $snackIndex, count: $count}';
}
