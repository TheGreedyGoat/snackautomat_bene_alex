import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/widgets/lcd_display/lcd_text.dart';
import 'package:snackautomat_bene_alex/widgets/lcd_display/ldc_separation_line.dart';

class LcdTitle extends StatefulWidget {
  const LcdTitle(
    this.data, {
    this.scroll = true,
    this.hasError = false,
    super.key,
  });
  final String data;
  final bool scroll;
  final bool hasError;

  @override
  State<LcdTitle> createState() => _LcdTitleState();
}

class _LcdTitleState extends State<LcdTitle> {
  String title = '';
  late final Timer? _timer;
  @override
  void initState() {
    super.initState();
    title = widget.data * 5;
    if (widget.scroll) {
      _timer = Timer.periodic(
        Duration(milliseconds: 500),
        (timer) {
          scrollTitle();
        },
      );
    }
  }

  void scrollTitle() {
    final lastChar = title[title.length - 1];
    title = title.replaceRange(title.length - 1, null, '');
    setState(() {
      title = '$lastChar$title';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LcdSeparationLine(),
        LcdText(
          title,
          fontSize: 25.0,
          hasError: widget.hasError,
        ),
        LcdSeparationLine(),
      ],
    );
  }
}
