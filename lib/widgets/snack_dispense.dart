import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';

///
class SnackDispense extends ConsumerWidget {
  ///
  const SnackDispense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(snackMachineProvider);

    return state.when(
      loading: () => Placeholder(color: Colors.yellow),
      error: (error, stackTrace) => Placeholder(
        color: Colors.red,
      ),
      data: (state) {
        final snack = state.ejectedSnack;
        return GestureDetector(
          onTap: () {
            ref.read(snackMachineProvider.notifier).emptyDispenseSlot();
          },
          child: Card(
            margin: const EdgeInsets.all(16.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(snack?.name ?? '=========='),
              ),
            ),
          ),
        );
      },
    );
  }
}
