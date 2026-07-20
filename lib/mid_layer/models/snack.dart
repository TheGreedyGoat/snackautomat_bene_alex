import 'package:freezed_annotation/freezed_annotation.dart';

part 'snack.freezed.dart';

/// stores information about a snack type
@freezed
class Snack with _$Snack {
  @override
  /// The snacks display name
  final String name;
  @override
  /// the snack's price
  final int price;
  @override
  /// url to the snack's display image
  final String image;

  /// stores information about a snack type
  const Snack({
    required this.name,
    required this.price,
    required this.image,
  });
}
