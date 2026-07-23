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
          itemCount: snacks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SnackSelectionTile(snackIndex: index),
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
      title: InkWell(
        onTap: () {
          print(snack.name);
          Navigator.pop(context, snackIndex);
        },
        child: SnackCard(
          snackIndex: snackIndex,
          showPriceAndCode: false,
        ),
      ),
    );
  }
}
