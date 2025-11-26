// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_history_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreHistoryPointModelImpl _$$ScoreHistoryPointModelImplFromJson(
  Map<String, dynamic> json,
) => _$ScoreHistoryPointModelImpl(
  date: json['date'] as String,
  value: (json['value'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ScoreHistoryPointModelImplToJson(
  _$ScoreHistoryPointModelImpl instance,
) => <String, dynamic>{'date': instance.date, 'value': instance.value};
