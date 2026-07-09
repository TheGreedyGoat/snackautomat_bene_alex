import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_tmp.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_card.dart';

class SnackDispense extends ConsumerWidget {
  const SnackDispense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final SnackTMP? snack;
    ref
        .watch(inventoryProvider)
        .whenData(
          (value) => snack = value.ejectedSnack,
        );
    return GestureDetector(
      onTap: () {
        ref.read(inventoryProvider.notifier).emptyDispenseSlot();
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: SizedBox.expand(
          child: Center(
            child: snack != null ? Text(snack!.name) : null,
          ),
        ),
      ),
    );
  }
}
