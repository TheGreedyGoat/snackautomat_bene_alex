import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/states/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

/// An abstract [VendingState] wich ignores input and waits for a specific timed event to occur (eg. dispensing of a snack)
abstract class AutoState extends VendingState {
  /// An abstract [VendingState] wich ignores input and waits for a specific timed event to occur (eg. dispensing of a snack)
  AutoState({
    required super.credit,
    required super.displayMessage,
    super.selectedSlot,
    super.hasError,
  }) : super(acceptsInput: false);

  @override
  VendingState onCoinInserted(Coin coin) => this;

  @override
  VendingState onReturnPressed() => this;

  @override
  VendingState onSnackSelected(int slot) => this;

  /// Returns the next state after the event waited for occured
  VendingState onFinished();

  /// call before onFinished to update the notifier'S information
  void updateNotifier(SnackMachineNotifier notifier);
}
