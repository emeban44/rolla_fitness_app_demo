// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InsightModel _$InsightModelFromJson(Map<String, dynamic> json) {
  return _InsightModel.fromJson(json);
}

/// @nodoc
mixin _$InsightModel {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this InsightModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightModelCopyWith<InsightModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightModelCopyWith<$Res> {
  factory $InsightModelCopyWith(
    InsightModel value,
    $Res Function(InsightModel) then,
  ) = _$InsightModelCopyWithImpl<$Res, InsightModel>;
  @useResult
  $Res call({String id, String text, String type});
}

/// @nodoc
class _$InsightModelCopyWithImpl<$Res, $Val extends InsightModel>
    implements $InsightModelCopyWith<$Res> {
  _$InsightModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightModelImplCopyWith<$Res>
    implements $InsightModelCopyWith<$Res> {
  factory _$$InsightModelImplCopyWith(
    _$InsightModelImpl value,
    $Res Function(_$InsightModelImpl) then,
  ) = __$$InsightModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, String type});
}

/// @nodoc
class __$$InsightModelImplCopyWithImpl<$Res>
    extends _$InsightModelCopyWithImpl<$Res, _$InsightModelImpl>
    implements _$$InsightModelImplCopyWith<$Res> {
  __$$InsightModelImplCopyWithImpl(
    _$InsightModelImpl _value,
    $Res Function(_$InsightModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? type = null}) {
    return _then(
      _$InsightModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightModelImpl extends _InsightModel {
  const _$InsightModelImpl({
    required this.id,
    required this.text,
    required this.type,
  }) : super._();

  factory _$InsightModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightModelImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final String type;

  @override
  String toString() {
    return 'InsightModel(id: $id, text: $text, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, type);

  /// Create a copy of InsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightModelImplCopyWith<_$InsightModelImpl> get copyWith =>
      __$$InsightModelImplCopyWithImpl<_$InsightModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightModelImplToJson(this);
  }
}

abstract class _InsightModel extends InsightModel {
  const factory _InsightModel({
    required final String id,
    required final String text,
    required final String type,
  }) = _$InsightModelImpl;
  const _InsightModel._() : super._();

  factory _InsightModel.fromJson(Map<String, dynamic> json) =
      _$InsightModelImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  String get type;

  /// Create a copy of InsightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightModelImplCopyWith<_$InsightModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
