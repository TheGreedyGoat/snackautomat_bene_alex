import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Riverpod test',
    () {
      final ref = ProviderContainer.test();
    },
  );
}
