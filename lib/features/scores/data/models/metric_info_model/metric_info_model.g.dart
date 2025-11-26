// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetricInfoModelImpl _$$MetricInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$MetricInfoModelImpl(
  title: json['title'] as String,
  description: json['description'] as String,
  baselineInfo: json['baselineInfo'] as String?,
);

Map<String, dynamic> _$$MetricInfoModelImplToJson(
  _$MetricInfoModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'baselineInfo': instance.baselineInfo,
};
