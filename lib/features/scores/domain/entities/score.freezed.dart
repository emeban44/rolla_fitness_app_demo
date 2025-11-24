// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Score {
  ScoreType get type => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;
  List<Metric> get metrics => throw _privateConstructorUsedError;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call({ScoreType type, int value, List<Metric> metrics});
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? metrics = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ScoreType,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int,
            metrics: null == metrics
                ? _value.metrics
                : metrics // ignore: cast_nullable_to_non_nullable
                      as List<Metric>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreImplCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$ScoreImplCopyWith(
    _$ScoreImpl value,
    $Res Function(_$ScoreImpl) then,
  ) = __$$ScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ScoreType type, int value, List<Metric> metrics});
}

/// @nodoc
class __$$ScoreImplCopyWithImpl<$Res>
    extends _$ScoreCopyWithImpl<$Res, _$ScoreImpl>
    implements _$$ScoreImplCopyWith<$Res> {
  __$$ScoreImplCopyWithImpl(
    _$ScoreImpl _value,
    $Res Function(_$ScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? metrics = null,
  }) {
    return _then(
      _$ScoreImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ScoreType,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
        metrics: null == metrics
            ? _value._metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<Metric>,
      ),
    );
  }
}

/// @nodoc

class _$ScoreImpl extends _Score {
  const _$ScoreImpl({
    required this.type,
    required this.value,
    required final List<Metric> metrics,
  }) : _metrics = metrics,
       super._();

  @override
  final ScoreType type;
  @override
  final int value;
  final List<Metric> _metrics;
  @override
  List<Metric> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

  @override
  String toString() {
    return 'Score(type: $type, value: $value, metrics: $metrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    value,
    const DeepCollectionEquality().hash(_metrics),
  );

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      __$$ScoreImplCopyWithImpl<_$ScoreImpl>(this, _$identity);
}

abstract class _Score extends Score {
  const factory _Score({
    required final ScoreType type,
    required final int value,
    required final List<Metric> metrics,
  }) = _$ScoreImpl;
  const _Score._() : super._();

  @override
  ScoreType get type;
  @override
  int get value;
  @override
  List<Metric> get metrics;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
