import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_card.dart';

class SnackView extends ConsumerWidget {
  const SnackView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snacks = ref.watch(inventoryProvider);
    return snacks.when(
      data: (data) => showSnacks(data.snackStorage.length),
      error: (error, stackTrace) => Center(
        child: Text('Fehler'),
      ),
      loading: () => CircularProgressIndicator(),
    );
  }

  Widget showSnacks(int numSnacks) {
    return ListView.builder(
      itemCount: (numSnacks / 3).ceil(),
      itemBuilder: (context, i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int j = 0; j < 3; j++)
              if (_index(i, j) < numSnacks)
                SnackSlotCard(snackIndex: _index(i, j))
              else
                SizedBox.square(
                  dimension: 200,
                ),
          ],
        );
      },
    );
  }

  int _index(int i, int j) {
    return j + 3 * i;
  }
}
