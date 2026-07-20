import 'package:freezed_annotation/freezed_annotation.dart';
part 'number_pad_state.freezed.dart';

/// Stores wich digits are currently entered via the numberpad.
@freezed
class NumberPadState with _$NumberPadState {
  /// The first digit of the resulting code
  @override
  final int? digit0;

  /// The second digit of the resulting code
  @override
  final int? digit1;

  /// The third digit of the resulting code
  @override
  final int? digit2;

  /// Stores wich digits are currently entered via the numberpad.
  ///
  /// - int [digit0]: The first digit of the resulting code
  /// - int [digit1]: The second digit of the resulting code
  /// - int [digit2]: The third digit of the resulting code
  ///
  /// example:
  /// digit0 = 1, digit1 = 2; digit2 = 3
  /// => value = 321;
  NumberPadState({this.digit0, this.digit1, this.digit2}) {
    print(this);
  }

  /// Stores wich digits are currently entered via the numberpad.
  NumberPadState.init() : this();

  @override
  String toString() {
    return '${digit2 ?? ''}${digit1 ?? ''}${digit0 ?? ''}'.padLeft(
      3,
      '-',
    );
  }

  /// returns the next [NumberPadState] after the button for[digit] is pressed
  ///
  /// - int [digit]: [0,9], the digit to put in
  ///
  /// checks in order: digit2, digit1, digit0. The first null value gets overridden.
  ///
  /// If all digits are already set, the state resets all digits and then sets digit2 to the given [digit]
  NumberPadState input(int digit) {
    if (digit > 9 || digit < 0) {
      throw ('Invalid num pad digit. Only numbers [0,9] allowed!');
    }
    if (digit2 == null) {
      return copyWith(digit2: digit);
    } else if (digit1 == null) {
      return copyWith(digit1: digit);
    } else if (digit0 == null) {
      return copyWith(digit0: digit);
    } else {
      return NumberPadState(digit2: digit);
    }
  }

  /// The number resulting of concatenationg digit2, digit1 & digit0.
  ///
  /// Only returns an actual value, if all 3 digits are set
  int? get value {
    if (digit0 == null || digit1 == null || digit2 == null) return null;
    return digit0! + 10 * digit1! + 10 * digit2!;
  }
}
