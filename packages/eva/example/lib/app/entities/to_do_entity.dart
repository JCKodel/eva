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

enum ToDoValidationFailure {
  titleIsEmpty,
  descriptionIsEmpty,
}

@freezed
class EditingToDoEntity with _$EditingToDoEntity {
  const factory EditingToDoEntity({
    required ToDoEntity toDo,
    required ToDoEntity originalToDo,
    required Iterable<ToDoValidationFailure> validationFailures,
  }) = _EditingToDoEntity;
}
