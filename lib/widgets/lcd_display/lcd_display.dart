import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/widgets/glass_pane.dart';

class LcdDisplay extends StatelessWidget {
  const LcdDisplay({
    required this.height,
    this.width,
    required this.child,
    this.title,
    super.key,
  });

  final Widget child;
  final String? title;
  final double? width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return _screen(
      child,
    );
  }

  Widget _screen(Widget content) => Card(
    color: Colors.black,
    child: SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          const GlassPane(
            borderRadius: 10,
          ),
        ],
      ),
    ),
  );

  Widget get _separationLine => SizedBox(
    height: 1,
    child: Container(
      color: Colors.green,
    ),
  );

  Widget _title(String content, [bool hasError = false]) => Column(
    children: [
      _separationLine,
      _text(content, 25.0, hasError),
      _separationLine,
    ],
  );

  Text _text(String data, [double? fontSize, bool hasError = false]) => Text(
    data,
    style: TextStyle(
      color: hasError ? Colors.red : Colors.green,
      fontFamily: 'FixedSys',
      fontSize: fontSize ?? 20,
    ),
    overflow: TextOverflow.clip,
    softWrap: false,
    maxLines: 1,
  );
}
