import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';
import 'package:snackautomat_bene_alex/mid_layer/models/snack_slot.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

class SnackSlotCard extends ConsumerStatefulWidget {
  const SnackSlotCard({required this.snackIndex, super.key});
  final int snackIndex;

  @override
  ConsumerState<SnackSlotCard> createState() => _SnackCardState();
}

class _SnackCardState extends ConsumerState<SnackSlotCard> {
  int get index => widget.snackIndex;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(vendingStateProvider.notifier).onSlotSelected(index);
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
          child: ref
              .watch(inventoryProvider)
              .when(
                data: (data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        data.getNameOfSnack(index),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            data.getPrice(index) == null
                                ? '-,--'
                                : MoneyConverter.centsToEutoDisplay(
                                    data.getPrice(index)!,
                                  ),
                          ),
                          Text(
                            data.getAmount(index) == null
                                ? '/'
                                : data.getAmount(index)!.toString(),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text('ERROR'),
                ),
                loading: () => CircularProgressIndicator(),
              ),
        ),
      ),
    );
  }
}
