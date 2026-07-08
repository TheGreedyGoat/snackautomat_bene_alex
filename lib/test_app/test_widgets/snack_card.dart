import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class SnackCard extends ConsumerStatefulWidget {
  const SnackCard({required this.snack, super.key});
  final SnackTMP snack;

  @override
  ConsumerState<SnackCard> createState() => _SnackCardState();
}

class _SnackCardState extends ConsumerState<SnackCard> {
  SnackTMP get snack => widget.snack;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(vendingStateProvider.notifier).onSnackSelected(snack);
      },
      child: Card(
        color: isHovered ? Colors.red.shade200 : Colors.grey,
        elevation: isHovered ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isHovered ? Colors.red : Colors.transparent,
            width: isHovered ? 2 : 0,
          ),
        ),
        child: SizedBox.square(
          dimension: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                snack.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(MoneyConverter.centsToEutoDisplay(snack.price)),
                  Text(snack.amount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
