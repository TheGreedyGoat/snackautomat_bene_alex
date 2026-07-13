import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';

///
class SnackTMP {
  ///
  final String name;

  ///
  final int price;

  ///
  const SnackTMP({
    required this.name,
    required this.price,
  });

  ///
  SnackSlot createSlot(int amount) => SnackSlot(snack: this, amount: amount);
}
