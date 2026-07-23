import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';

/// State if something within the machine has gone wrong
class ErrorState extends ManualState {
  /// State if something within the machine has gone wrong

  ErrorState({
    required super.credit,
    required super.numberPadState,
    super.displayMessage = 'ERROR',
  }) : super(mode: LcdMessageMode.error, autoReset: true);

  @override
  VendingState onCoinInserted(Coin coin) => ErrorState(
    credit: credit + coin.worth,
    displayMessage: displayMessage,
    numberPadState: numberPadState,
  );

  @override
  VendingState setNumPadState(NumberPadState newState) => this;
}
