import 'package:freezed_annotation/freezed_annotation.dart';

part 'snack.freezed.dart';

@freezed
class Snack with _$Snack {
  final String name;
  final int price;
  final String image;

  const Snack({
    required this.name,
    required this.price,
    required this.image,
  });
}
