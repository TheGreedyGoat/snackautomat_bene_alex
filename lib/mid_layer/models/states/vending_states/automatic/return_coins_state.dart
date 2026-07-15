import 'package:snackautomat_bene_alex/mid_layer/models/states/number_pad_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

/// The machine is currently returning coins
class ReturnCoinsState extends AutoState {
  /// The machine is currently returning coins
  ReturnCoinsState({
    required super.credit,
    super.displayMessage = 'Rückgabe...',
    super.hasError,
  });

  @override
  VendingState onFinished() => IdleState(numberPadState: NumberPadState.init());

  @override
  void updateNotifier(SnackMachineNotifier notifier) {
    if (!notifier.tryDispenseChange()) {
      throw ('Error while Retuning Coins: Tried dispensing impossible credit $credit');
    }
  }
}
