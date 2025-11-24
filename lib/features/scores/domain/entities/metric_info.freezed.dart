// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MetricInfo {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get baselineInfo => throw _privateConstructorUsedError;

  /// Create a copy of MetricInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricInfoCopyWith<MetricInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricInfoCopyWith<$Res> {
  factory $MetricInfoCopyWith(
    MetricInfo value,
    $Res Function(MetricInfo) then,
  ) = _$MetricInfoCopyWithImpl<$Res, MetricInfo>;
  @useResult
  $Res call({String title, String description, String? baselineInfo});
}

/// @nodoc
class _$MetricInfoCopyWithImpl<$Res, $Val extends MetricInfo>
    implements $MetricInfoCopyWith<$Res> {
  _$MetricInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? baselineInfo = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            baselineInfo: freezed == baselineInfo
                ? _value.baselineInfo
                : baselineInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetricInfoImplCopyWith<$Res>
    implements $MetricInfoCopyWith<$Res> {
  factory _$$MetricInfoImplCopyWith(
    _$MetricInfoImpl value,
    $Res Function(_$MetricInfoImpl) then,
  ) = __$$MetricInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, String? baselineInfo});
}

/// @nodoc
class __$$MetricInfoImplCopyWithImpl<$Res>
    extends _$MetricInfoCopyWithImpl<$Res, _$MetricInfoImpl>
    implements _$$MetricInfoImplCopyWith<$Res> {
  __$$MetricInfoImplCopyWithImpl(
    _$MetricInfoImpl _value,
    $Res Function(_$MetricInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetricInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? baselineInfo = freezed,
  }) {
    return _then(
      _$MetricInfoImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        baselineInfo: freezed == baselineInfo
            ? _value.baselineInfo
            : baselineInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MetricInfoImpl implements _MetricInfo {
  const _$MetricInfoImpl({
    required this.title,
    required this.description,
    this.baselineInfo,
  });

  @override
  final String title;
  @override
  final String description;
  @override
  final String? baselineInfo;

  @override
  String toString() {
    return 'MetricInfo(title: $title, description: $description, baselineInfo: $baselineInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricInfoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.baselineInfo, baselineInfo) ||
                other.baselineInfo == baselineInfo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, baselineInfo);

  /// Create a copy of MetricInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricInfoImplCopyWith<_$MetricInfoImpl> get copyWith =>
      __$$MetricInfoImplCopyWithImpl<_$MetricInfoImpl>(this, _$identity);
}

abstract class _MetricInfo implements MetricInfo {
  const factory _MetricInfo({
    required final String title,
    required final String description,
    final String? baselineInfo,
  }) = _$MetricInfoImpl;

  @override
  String get title;
  @override
  String get description;
  @override
  String? get baselineInfo;

  /// Create a copy of MetricInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricInfoImplCopyWith<_$MetricInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
