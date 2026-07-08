import 'package:flutter/widgets.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/coin_slit.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/info_screen.dart';
import 'package:snackautomat_bene_alex/test_app/test_widgets/return_button.dart';

class ControlPad extends StatelessWidget {
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          InfoScreen(),
          Row(
            children: [
              CoinSlit(),
              ReturnButton(),
            ],
          ),
        ],
      ),
    );
  }
}
