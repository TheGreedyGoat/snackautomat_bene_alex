import 'dart:math';

import 'package:flutter/material.dart';

class NukaColaSign extends StatefulWidget {
  const NukaColaSign({super.key});

  @override
  State<NukaColaSign> createState() => _NukaColaSignState();
}

class _NukaColaSignState extends State<NukaColaSign> {
  static const _path = 'assets/images/nuka_cola_sign/';
  bool _bottleOn = false;
  bool _cOn = false;

  bool _continueAnimation = true;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _bottleBlink();
    _cBlink();
  }

  @override
  void dispose() {
    _continueAnimation = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getImage('all_off'),
        _getImage('c_off'),
        _getImage('main_on'),
        if (_cOn) _getImage('c_on'),
        if (_bottleOn) _getImage('bottle_on'),
      ],
    );
  }

  Image _getImage(String name) => Image(
    image: AssetImage('$_path$name.png'),
  );

  Future<void> _bottleBlink() async {
    if (!_continueAnimation) return;
    await _delay(1);
    setState(() {
      _bottleOn = !_bottleOn;
    });
    _bottleBlink();
  }

  void _cBlink() async {
    if (!_continueAnimation) return;
    setState(() {
      _cOn = true;
    });
    await _delay(_random.nextInt(4) + 1);
    setState(() {
      _cOn = false;
    });

    final int blinks = _random.nextInt(5);
    for (int i = 0; i < blinks; i++) {
      await _delay(0, _random.nextInt(150) + 50);
      setState(() {
        _cOn = !_cOn;
      });
    }
    _cBlink();
  }

  Future<void> _delay([int seconds = 0, int milliseconds = 0]) async {
    await Future.delayed(
      Duration(seconds: seconds, milliseconds: milliseconds),
    );
  }
}
