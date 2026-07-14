import 'package:freezed_annotation/freezed_annotation.dart';
part 'number_pad_state.freezed.dart';

@freezed
class NumberPadState with _$NumberPadState {
  final int? digit0;
  final int? digit1;
  final int? digit2;
  NumberPadState({this.digit0, this.digit1, this.digit2});
  NumberPadState.init() : this();

  @override
  String toString() => '${digit2 ?? '-'}${digit1 ?? '-'}${digit0 ?? '-'}';

  NumberPadState input(int digit) {
    if (digit > 9 || digit < 0) {
      throw ('Invalid num pad digit. Only numbers [0,9] allowed!');
    }
    if (digit0 == null) {
      return copyWith(digit0: digit);
    } else if (digit1 == null) {
      return copyWith(digit1: digit);
    } else if (digit2 == null) {
      return copyWith(digit2: digit);
    } else {
      return this;
    }
  }

  int? get value {
    if (digit0 == null || digit1 == null || digit2 == null) return null;
    return digit0! + 10 * digit1! + 10 * digit2!;
  }
}
