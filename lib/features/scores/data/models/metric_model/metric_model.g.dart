// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetricModelImpl _$$MetricModelImplFromJson(Map<String, dynamic> json) =>
    _$MetricModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      displayValue: json['displayValue'] as String,
      score: (json['score'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MetricModelImplToJson(_$MetricModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'displayValue': instance.displayValue,
      'score': instance.score,
    };
