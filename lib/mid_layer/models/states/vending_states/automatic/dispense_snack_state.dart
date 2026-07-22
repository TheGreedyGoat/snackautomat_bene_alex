import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/no_selection_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

/// The machine is currently dispensing a snack
class DispenseSnackState extends AutoState {
  /// The machine is currently dispensing a snack
  DispenseSnackState({
    required super.credit,
    required super.selectedSlot,
    super.displayMessage = 'Warenausgabe...',
  }) : super(mode: LcdMessageMode.normal) {
    assert(selectedSlot != null);
  }

  @override
  VendingState onFinished() => credit == 0
      ? IdleState(numberPadState: NumberPadState.init())
      : NoSelectionState(credit: credit, numberPadState: NumberPadState.init());

  @override
  void updateNotifier(SnackMachineNotifier notifier) {
    notifier.dispenseSnack(selectedSlot!);
  }
}
