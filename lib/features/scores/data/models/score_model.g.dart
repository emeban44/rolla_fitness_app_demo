// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreModelImpl _$$ScoreModelImplFromJson(Map<String, dynamic> json) =>
    _$ScoreModelImpl(
      type: json['type'] as String,
      value: (json['value'] as num).toInt(),
      metrics: (json['metrics'] as List<dynamic>)
          .map((e) => MetricModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScoreModelImplToJson(_$ScoreModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'metrics': instance.metrics,
    };
