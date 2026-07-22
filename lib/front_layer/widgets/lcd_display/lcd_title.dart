import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_message_mode.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_text.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/lcd_display/lcd_separation_line.dart';

/// Displays the text as a large banner within seperation lines
///
/// The text can be displayed either as single or repetitively and scrolling.
class LcdTitle extends StatefulWidget {
  /// Displays the text as a large banner within seperation lines
  ///
  /// The text can be displayed either as single or repetitively and scrolling.
  const LcdTitle(
    this.data, {
    this.scroll = true,
    this.mode = LcdMessageMode.normal,
    super.key,
  });

  /// The title's content
  final String data;

  /// set to true to make the title scrolling
  final bool scroll;

  final LcdMessageMode mode;

  @override
  State<LcdTitle> createState() => _LcdTitleState();
}

class _LcdTitleState extends State<LcdTitle> {
  String title = '';
  late final Timer? _timer;
  @override
  void initState() {
    super.initState();
    title = widget.data;
    if (widget.scroll) {
      title += ' ';
      title *= 5;
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
        LcdSeparationLine(mode: widget.mode),
        LcdText(
          title,
          fontSize: 25.0,
          mode: widget.mode,
        ),
        LcdSeparationLine(mode: widget.mode),
      ],
    );
  }
}
