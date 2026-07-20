import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';

/// The provider for the snack machine
final snackMachineProvider = AsyncNotifierProvider(
  () => SnackMachineNotifier(),
);
