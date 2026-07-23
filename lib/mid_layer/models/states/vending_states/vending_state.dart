import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';

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

  final LcdMessageMode mode;

  /// The state of the vending machine's numberpad
  final NumberPadState numberPadState;

  /// Describes the general state within the 'vending process' eg. if a snack is selected, what value of coins got insertet etc.

  VendingState({
    /// Describes the general state within the 'vending process' eg. if a snack is selected, what value of coins got insertet etc.
    required this.credit,
    required this.acceptsInput,
    required this.displayMessage,
    required this.numberPadState,
    this.mode = LcdMessageMode.normal,
    this.selectedSlot,
  });

  /// Returns the state to transition to when a coin ist inserted
  VendingState onCoinInserted(Coin coin);

  /// Returns the state to transition to when the 'Return' button is pressed
  VendingState onReturnPressed();

  /// Returns the updated [VendingState] resulting of the passed NumberPadState [newState]
  VendingState setNumPadState(NumberPadState newState);

  /// returns the current credit as a formatted € -String
  String get creditDisplay => MoneyConverter.centsToEutoDisplay(credit);

  @override
  String toString() => '$credit, $selectedSlot';
}
