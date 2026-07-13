import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';

/// Describes the general state within the 'vending process' eg. if a snack is selected, what value of coins got insertet etc.
abstract class VendingState {
  /// The total worth of the currently inserted coins
  ///
  /// Has to be >= a selected snack's value to buy it
  final int credit;

  /// The index of the selected SnackSlot, if one is selected
  final int? selectedSlot;

  /// Does the current state react to any manual user input?
  final bool acceptsInput;

  /// A message to display information to the user
  final String displayMessage;

  /// true, if the last state transistion was caused by some kind of error (eg snack not available)
  final bool hasError;

  /// Describes the general state within the 'vending process' eg. if a snack is selected, what value of coins got insertet etc.

  VendingState({
    /// Describes the general state within the 'vending process' eg. if a snack is selected, what value of coins got insertet etc.
    required this.credit,
    required this.acceptsInput,
    required this.displayMessage,
    this.selectedSlot,
    this.hasError = false,
  });

  /// Returns the state to transition to when a snack is selected
  VendingState onSnackSelected(int slot);

  /// Returns the state to transition to when a coin ist inserted
  VendingState onCoinInserted(Coin coin);

  /// Returns the state to transition to when the 'Return' button is pressed
  VendingState onReturnPressed();

  /// returns the current credit as a formatted € -String
  String get creditDisplay => MoneyConverter.centsToEutoDisplay(credit);
}
