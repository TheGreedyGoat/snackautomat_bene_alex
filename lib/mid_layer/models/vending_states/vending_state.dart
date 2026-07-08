import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

abstract class VendingState {
  final int credit;
  final SnackTMP? selectedSnack;

  VendingState({
    required this.credit,
    this.selectedSnack,
  });

  VendingState onSnackSelected(SnackTMP snack);
  VendingState onCoinInserted(Coin coin);
  VendingState onReturnPressed();
}
