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
    required Iterable<ToDoValidationFailure> validationFailures,
  }) = _EditingToDoEntity;
}

@freezed
class SavingToDoEntity with _$SavingToDoEntity {
  const factory SavingToDoEntity({
    required ToDoEntity toDo,
  }) = _SavingToDoEntity;
}

@freezed
class DeletedToDoEntity with _$DeletedToDoEntity {
  const factory DeletedToDoEntity({
    required int toDoId,
  }) = _DeletedToDoEntity;
}
