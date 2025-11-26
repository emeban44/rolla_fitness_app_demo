// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MetricInfoModel _$MetricInfoModelFromJson(Map<String, dynamic> json) {
  return _MetricInfoModel.fromJson(json);
}

/// @nodoc
mixin _$MetricInfoModel {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get baselineInfo => throw _privateConstructorUsedError;

  /// Serializes this MetricInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetricInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricInfoModelCopyWith<MetricInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricInfoModelCopyWith<$Res> {
  factory $MetricInfoModelCopyWith(
    MetricInfoModel value,
    $Res Function(MetricInfoModel) then,
  ) = _$MetricInfoModelCopyWithImpl<$Res, MetricInfoModel>;
  @useResult
  $Res call({String title, String description, String? baselineInfo});
}

/// @nodoc
class _$MetricInfoModelCopyWithImpl<$Res, $Val extends MetricInfoModel>
    implements $MetricInfoModelCopyWith<$Res> {
  _$MetricInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricInfoModel
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
abstract class _$$MetricInfoModelImplCopyWith<$Res>
    implements $MetricInfoModelCopyWith<$Res> {
  factory _$$MetricInfoModelImplCopyWith(
    _$MetricInfoModelImpl value,
    $Res Function(_$MetricInfoModelImpl) then,
  ) = __$$MetricInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, String? baselineInfo});
}

/// @nodoc
class __$$MetricInfoModelImplCopyWithImpl<$Res>
    extends _$MetricInfoModelCopyWithImpl<$Res, _$MetricInfoModelImpl>
    implements _$$MetricInfoModelImplCopyWith<$Res> {
  __$$MetricInfoModelImplCopyWithImpl(
    _$MetricInfoModelImpl _value,
    $Res Function(_$MetricInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetricInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? baselineInfo = freezed,
  }) {
    return _then(
      _$MetricInfoModelImpl(
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
@JsonSerializable()
class _$MetricInfoModelImpl extends _MetricInfoModel {
  const _$MetricInfoModelImpl({
    required this.title,
    required this.description,
    this.baselineInfo,
  }) : super._();

  factory _$MetricInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricInfoModelImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String? baselineInfo;

  @override
  String toString() {
    return 'MetricInfoModel(title: $title, description: $description, baselineInfo: $baselineInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricInfoModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.baselineInfo, baselineInfo) ||
                other.baselineInfo == baselineInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, baselineInfo);

  /// Create a copy of MetricInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricInfoModelImplCopyWith<_$MetricInfoModelImpl> get copyWith =>
      __$$MetricInfoModelImplCopyWithImpl<_$MetricInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricInfoModelImplToJson(this);
  }
}

abstract class _MetricInfoModel extends MetricInfoModel {
  const factory _MetricInfoModel({
    required final String title,
    required final String description,
    final String? baselineInfo,
  }) = _$MetricInfoModelImpl;
  const _MetricInfoModel._() : super._();

  factory _MetricInfoModel.fromJson(Map<String, dynamic> json) =
      _$MetricInfoModelImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String? get baselineInfo;

  /// Create a copy of MetricInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricInfoModelImplCopyWith<_$MetricInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
