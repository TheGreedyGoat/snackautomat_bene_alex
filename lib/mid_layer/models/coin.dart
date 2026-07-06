import 'package:my_utils/utility/formatters.dart';
import 'package:my_utils/utility/money_converter.dart';

/// Respräsentiert die unterstützten Münzarten
enum Coin {
  ///
  euro2(200),

  ///
  euro1(100),

  ///
  cents50(50),

  ///
  cents20(20),

  ///
  cents10(10),

  ///
  cents5(5),

  ///
  cents2(2),

  ///
  cents1(1);

  /// Der zugehörige Wert der Münze
  final int worthInCents;
  const Coin(this.worthInCents);

  // @override
  String toString() => MoneyConverter.centsToEutoDisplay(worthInCents);
}
