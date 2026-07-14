// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snack_machine_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SnackMachineState {

 CoinStack get coinStorage; CoinStack get changeSlot; List<SnackStack> get snackStorage; Snack? get ejectedSnack; VendingState get vendingState; NumberPadState get numberPadState;
/// Create a copy of SnackMachineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnackMachineStateCopyWith<SnackMachineState> get copyWith => _$SnackMachineStateCopyWithImpl<SnackMachineState>(this as SnackMachineState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnackMachineState&&(identical(other.coinStorage, coinStorage) || other.coinStorage == coinStorage)&&(identical(other.changeSlot, changeSlot) || other.changeSlot == changeSlot)&&const DeepCollectionEquality().equals(other.snackStorage, snackStorage)&&(identical(other.ejectedSnack, ejectedSnack) || other.ejectedSnack == ejectedSnack)&&(identical(other.vendingState, vendingState) || other.vendingState == vendingState)&&(identical(other.numberPadState, numberPadState) || other.numberPadState == numberPadState));
}


@override
int get hashCode => Object.hash(runtimeType,coinStorage,changeSlot,const DeepCollectionEquality().hash(snackStorage),ejectedSnack,vendingState,numberPadState);

@override
String toString() {
  return 'SnackMachineState(coinStorage: $coinStorage, changeSlot: $changeSlot, snackStorage: $snackStorage, ejectedSnack: $ejectedSnack, vendingState: $vendingState, numberPadState: $numberPadState)';
}


}

/// @nodoc
abstract mixin class $SnackMachineStateCopyWith<$Res>  {
  factory $SnackMachineStateCopyWith(SnackMachineState value, $Res Function(SnackMachineState) _then) = _$SnackMachineStateCopyWithImpl;
@useResult
$Res call({
 CoinStack coinStorage, CoinStack changeSlot, List<SnackStack> snackStorage, NumberPadState numberPadState, Snack? ejectedSnack, VendingState vendingState
});




}
/// @nodoc
class _$SnackMachineStateCopyWithImpl<$Res>
    implements $SnackMachineStateCopyWith<$Res> {
  _$SnackMachineStateCopyWithImpl(this._self, this._then);

  final SnackMachineState _self;
  final $Res Function(SnackMachineState) _then;

/// Create a copy of SnackMachineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coinStorage = null,Object? changeSlot = null,Object? snackStorage = null,Object? numberPadState = null,Object? ejectedSnack = freezed,Object? vendingState = null,}) {
  return _then(SnackMachineState(
coinStorage: null == coinStorage ? _self.coinStorage : coinStorage // ignore: cast_nullable_to_non_nullable
as CoinStack,changeSlot: null == changeSlot ? _self.changeSlot : changeSlot // ignore: cast_nullable_to_non_nullable
as CoinStack,snackStorage: null == snackStorage ? _self.snackStorage : snackStorage // ignore: cast_nullable_to_non_nullable
as List<SnackStack>,numberPadState: null == numberPadState ? _self.numberPadState : numberPadState // ignore: cast_nullable_to_non_nullable
as NumberPadState,ejectedSnack: freezed == ejectedSnack ? _self.ejectedSnack : ejectedSnack // ignore: cast_nullable_to_non_nullable
as Snack?,vendingState: null == vendingState ? _self.vendingState : vendingState // ignore: cast_nullable_to_non_nullable
as VendingState,
  ));
}

}


/// Adds pattern-matching-related methods to [SnackMachineState].
extension SnackMachineStatePatterns on SnackMachineState {
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
