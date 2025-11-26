// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_history_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ScoreHistoryPoint {
  DateTime get date => throw _privateConstructorUsedError;
  int? get value => throw _privateConstructorUsedError;

  /// Create a copy of ScoreHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreHistoryPointCopyWith<ScoreHistoryPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreHistoryPointCopyWith<$Res> {
  factory $ScoreHistoryPointCopyWith(
    ScoreHistoryPoint value,
    $Res Function(ScoreHistoryPoint) then,
  ) = _$ScoreHistoryPointCopyWithImpl<$Res, ScoreHistoryPoint>;
  @useResult
  $Res call({DateTime date, int? value});
}

/// @nodoc
class _$ScoreHistoryPointCopyWithImpl<$Res, $Val extends ScoreHistoryPoint>
    implements $ScoreHistoryPointCopyWith<$Res> {
  _$ScoreHistoryPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = freezed}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreHistoryPointImplCopyWith<$Res>
    implements $ScoreHistoryPointCopyWith<$Res> {
  factory _$$ScoreHistoryPointImplCopyWith(
    _$ScoreHistoryPointImpl value,
    $Res Function(_$ScoreHistoryPointImpl) then,
  ) = __$$ScoreHistoryPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int? value});
}

/// @nodoc
class __$$ScoreHistoryPointImplCopyWithImpl<$Res>
    extends _$ScoreHistoryPointCopyWithImpl<$Res, _$ScoreHistoryPointImpl>
    implements _$$ScoreHistoryPointImplCopyWith<$Res> {
  __$$ScoreHistoryPointImplCopyWithImpl(
    _$ScoreHistoryPointImpl _value,
    $Res Function(_$ScoreHistoryPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = freezed}) {
    return _then(
      _$ScoreHistoryPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ScoreHistoryPointImpl implements _ScoreHistoryPoint {
  const _$ScoreHistoryPointImpl({required this.date, this.value});

  @override
  final DateTime date;
  @override
  final int? value;

  @override
  String toString() {
    return 'ScoreHistoryPoint(date: $date, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreHistoryPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, value);

  /// Create a copy of ScoreHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreHistoryPointImplCopyWith<_$ScoreHistoryPointImpl> get copyWith =>
      __$$ScoreHistoryPointImplCopyWithImpl<_$ScoreHistoryPointImpl>(
        this,
        _$identity,
      );
}

abstract class _ScoreHistoryPoint implements ScoreHistoryPoint {
  const factory _ScoreHistoryPoint({
    required final DateTime date,
    final int? value,
  }) = _$ScoreHistoryPointImpl;

  @override
  DateTime get date;
  @override
  int? get value;

  /// Create a copy of ScoreHistoryPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreHistoryPointImplCopyWith<_$ScoreHistoryPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
