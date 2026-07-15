// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'number_pad_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NumberPadState {

 int? get digit0; int? get digit1; int? get digit2;
/// Create a copy of NumberPadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumberPadStateCopyWith<NumberPadState> get copyWith => _$NumberPadStateCopyWithImpl<NumberPadState>(this as NumberPadState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumberPadState&&(identical(other.digit0, digit0) || other.digit0 == digit0)&&(identical(other.digit1, digit1) || other.digit1 == digit1)&&(identical(other.digit2, digit2) || other.digit2 == digit2));
}


@override
int get hashCode => Object.hash(runtimeType,digit0,digit1,digit2);



}

/// @nodoc
abstract mixin class $NumberPadStateCopyWith<$Res>  {
  factory $NumberPadStateCopyWith(NumberPadState value, $Res Function(NumberPadState) _then) = _$NumberPadStateCopyWithImpl;
@useResult
$Res call({
 int? digit0, int? digit1, int? digit2
});




}
/// @nodoc
class _$NumberPadStateCopyWithImpl<$Res>
    implements $NumberPadStateCopyWith<$Res> {
  _$NumberPadStateCopyWithImpl(this._self, this._then);

  final NumberPadState _self;
  final $Res Function(NumberPadState) _then;

/// Create a copy of NumberPadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? digit0 = freezed,Object? digit1 = freezed,Object? digit2 = freezed,}) {
  return _then(NumberPadState(
digit0: freezed == digit0 ? _self.digit0 : digit0 // ignore: cast_nullable_to_non_nullable
as int?,digit1: freezed == digit1 ? _self.digit1 : digit1 // ignore: cast_nullable_to_non_nullable
as int?,digit2: freezed == digit2 ? _self.digit2 : digit2 // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NumberPadState].
extension NumberPadStatePatterns on NumberPadState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
