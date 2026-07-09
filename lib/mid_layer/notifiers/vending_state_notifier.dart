import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/coin.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/auto_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/automatic/dispense_snack_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual/idle_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/manual_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/vending_states/vending_state.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class VendingStateNotifier extends Notifier<VendingState> {
  @override
  VendingState build() => IdleState();

  Timer? _resetTimer;

  InventoryNotifier get notifier => ref.read(inventoryProvider.notifier);

  void _checkForDispense() {
    int? price;
    ref.read(inventoryProvider).whenData(
      (value) {
        price = value.getPrice(state.selectedSlot);
      },
    );

    if (price != null &&
        state.credit >= price! &&
        notifier.checkForChange(
              state.credit - price!,
            ) !=
            null) {
      state = DispenseSnackState(
        credit: state.credit,
        selectedSlot: state.selectedSlot,
      );
    }
  }

  void onSlotSelected(int slot) {
    if (!state.acceptsInput) return;
    state = state.onSnackSelected(slot);
    _checkForDispense();
  }

  void onCoinInserted(Coin coin) {
    if (!state.acceptsInput) return;
    notifier.insertCoin(coin);
    print(state.runtimeType);
    state = state.onCoinInserted(coin);
    print(state.runtimeType);
    print(state.runtimeType);
  }

  void onReturnPressed() {
    if (!state.acceptsInput) return;
    notifier.tryGetChange(state.credit);
    state = state.onReturnPressed();
  }

  void onFinished() {
    if (state is AutoState) {
      (state as AutoState).updateInventory(notifier);
      state = (state as AutoState).onFinished();
    }
  }

  @override
  set state(VendingState newState) {
    super.state = newState;
    _resetTimer?.cancel();

    if (state is ManualState && state is! IdleState) {
      _resetTimer = Timer(
        Duration(seconds: 500),
        _reset,
      );
    }
    if (state is AutoState) {
      Future.delayed(Duration(seconds: 5)).then(
        (_) => onFinished(),
      );
    }
  }

  void _reset() {
    print(notifier.tryGetChange(state.credit));
    state = IdleState();
  }
}
