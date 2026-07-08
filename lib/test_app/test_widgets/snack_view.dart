import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/snack_card.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/test_providers.dart';

class SnackView extends ConsumerWidget {
  const SnackView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snacks = ref.watch(inventoryProvider);
    return snacks.when(
      data: (data) => showSnacks(data.snackStorage),
      error: (error, stackTrace) => Center(
        child: Text('Fehler'),
      ),
      loading: () => CircularProgressIndicator(),
    );
  }

  Widget showSnacks(List<SnackTMP> snacks) {
    return ListView.builder(
      itemCount: (snacks.length / 3).ceil(),
      itemBuilder: (context, i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int j = 0; j < 3; j++)
              if (_index(i, j) < snacks.length)
                SnackCard(snack: snacks[_index(i, j)])
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
