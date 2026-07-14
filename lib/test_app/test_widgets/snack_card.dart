import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

///
class SnackSlotCard extends ConsumerStatefulWidget {
  ///
  const SnackSlotCard({
    required this.snackIndex,
    required this.dimension,
    super.key,
  });

  ///
  final int snackIndex;

  ///
  final double dimension;

  @override
  ConsumerState<SnackSlotCard> createState() => _SnackCardState();
}

class _SnackCardState extends ConsumerState<SnackSlotCard> {
  int get index => widget.snackIndex;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(snackMachineProvider);
    final snackSlot = state.getSlot(index);
    return GestureDetector(
      onTap: () {
        ref.read(snackMachineProvider.notifier).onSlotSelected(index);
      },
      child: Card(
        margin: const EdgeInsets.all(0),
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
          dimension: widget.dimension,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                snackSlot?.snackName ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    snackSlot?.priceDisplay ?? '-,--',
                  ),
                  Text(
                    snackSlot?.count.toString() ?? '--',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
