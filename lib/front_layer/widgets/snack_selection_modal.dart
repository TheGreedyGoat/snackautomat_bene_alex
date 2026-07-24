import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_card.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/snack_machine_notifier.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class SnackSelectionModal extends StatelessWidget {
  const SnackSelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: snacks.length + 1,
          itemBuilder: (context, index) {
            return index == 0
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context, -1);
                    },
                    title: Text('Remove Item'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SnackSelectionTile(snackIndex: index - 1),
                  );
          },
        ),
      ),
    );
  }
}

class SnackSelectionTile extends StatelessWidget {
  const SnackSelectionTile({required this.snackIndex, super.key});
  final int snackIndex;

  Snack get snack => snacks[snackIndex];
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context, snackIndex);
      },
      title: SnackCard(
        snackIndex: snackIndex,
        showPriceAndCode: false,
      ),
    );
  }
}
