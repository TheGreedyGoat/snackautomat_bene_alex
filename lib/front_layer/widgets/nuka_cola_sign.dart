import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snackautomat_bene_alex/front_layer/widgets/backgrounds_overlays/rusty.dart';

/// an animated Nuka Cola Neon-sign
class NukaColaSign extends StatefulWidget {
  /// an animated Nuka Cola Neon-sign
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

  double angleLimit = 0.05;
  double angleP = 0;
  double deltaP = 0.0001;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  @override
  void dispose() {
    _continueAnimation = false;
    super.dispose();
  }

  void _animate() {
    _bottleBlink();
    _cBlink();
    _rotate();
  }

  void _toggleAnimation() {
    _continueAnimation = !_continueAnimation;
    _animate();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleAnimation(),
      child: Transform.rotate(
        angle: 2 * pi * angleP,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 5)],
          ),
          child: Rusty(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Rusty(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    _getImage('all_off'),
                    _getImage('c_off'),
                    _getImage('main_on'),
                    if (_cOn) _getImage('c_on'),
                    if (_bottleOn) _getImage('bottle_on'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _rotate() async {
    if (!_continueAnimation) return;
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {
      angleP += deltaP;
      angleP = angleP.clamp(-angleLimit, angleLimit);
    });
    if (angleP.abs() == angleLimit) {
      deltaP = -deltaP;
    }
    _rotate();
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
    unawaited(_bottleBlink());
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

    final int blinks = _random.nextInt(10) + 1;
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
