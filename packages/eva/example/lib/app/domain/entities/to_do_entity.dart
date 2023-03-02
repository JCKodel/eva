import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do_entity.freezed.dart";

@freezed
class ToDoEntity with _$ToDoEntity {
  const factory ToDoEntity({
    int? id,
    required String title,
    required String description,
    required DateTime creationDate,
    required bool completed,
    DateTime? completionDate,
  }) = _ToDoEntity;
}
