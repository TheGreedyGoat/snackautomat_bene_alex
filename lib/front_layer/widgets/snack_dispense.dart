import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/snack_card.dart';
import 'package:snackautomat_bene_alex/mid_layer/providers.dart';

/// snack output dispenser
class SnackDispense extends ConsumerStatefulWidget {
  const SnackDispense({super.key});

  @override
  ConsumerState<SnackDispense> createState() => _SnackDispenseState();
}

class _SnackDispenseState extends ConsumerState<SnackDispense>
    with SingleTickerProviderStateMixin {
  static const _stepX = 36.0;
  static const _snackSize = 100.0;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.value > 0.5) {
      ref.read(snackMachineProvider.notifier).emptyDispenseSlot();
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(snackMachineProvider);

    return state.when(
      loading: () => const Placeholder(color: Colors.yellow),
      error: (_, _) => const Placeholder(color: Colors.red),
      data: (state) {
        final snackIndices = state.ejectedSnackIds;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: GestureDetector(
            onTap: _onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Color(0xFF141414)),
                if (snackIndices.isNotEmpty)
                  Center(
                    child: SizedBox(
                      width: _snackSize + (snackIndices.length - 1) * _stepX,
                      height: _snackSize,
                      child: Stack(
                        children: [
                          for (var i = 0; i < snackIndices.length; i++)
                            Positioned(
                              left: i * _stepX,
                              width: _snackSize,
                              height: _snackSize,
                              child: FittedBox(
                                child: SnackCard(
                                  snackIndex: snackIndices[i],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, _) => Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateX(-1.75 * _controller.value),
                    child: Rusty(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B3E2A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF3A2418),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 72,
                          height: 14,
                          child: ColoredBox(color: Color(0xFF7A7268)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
