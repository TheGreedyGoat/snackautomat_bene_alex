import 'package:flutter/material.dart';
import 'package:my_utils/utility/money_converter.dart';

/// Respräsentiert die unterstützten Münzarten
enum Coin {
  ///
  euro2(
    200,
    coinColor: Colors.blueGrey,
    coinWidth: 60,
  ),

  ///
  euro1(
    100,
    coinColor: Colors.amber,
    coinWidth: 53,
  ),

  ///
  cents50(50, coinColor: Colors.amber, coinWidth: 53),

  ///
  cents20(20, coinColor: Colors.amber, coinWidth: 50),

  ///
  cents10(10, coinColor: Colors.amber, coinWidth: 40),

  ///
  cents5(5, coinColor: Color.fromARGB(255, 94, 34, 7), coinWidth: 45),

  ///
  cents2(2, coinColor: Color.fromARGB(255, 94, 34, 7), coinWidth: 35),

  ///
  cents1(1, coinColor: Color.fromARGB(255, 94, 34, 7), coinWidth: 30);

  /// Der zugehörige Wert der Münze
  final int worth;
  final Color coinColor;
  final double coinWidth;
  const Coin(this.worth, {required this.coinColor, required this.coinWidth});

  @override
  String toString() => MoneyConverter.centsToEutoDisplay(worth);
}
