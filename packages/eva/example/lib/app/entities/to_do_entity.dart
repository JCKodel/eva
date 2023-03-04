import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do_entity.freezed.dart";

/// This represents a to-do for our domain and UI.
///
/// Since we need value equality and a `copyWith` method,
/// we are using the freezed package here to create those
/// things for us (check freezed package for more detail)
@freezed
class ToDoEntity with _$ToDoEntity {
  const factory ToDoEntity({
    /// Every object needs a key (`null` represents a new object)
    int? id,

    /// The to-do title.
    required String title,

    /// The to-do description.
    required String description,

    /// The date and time this to-do was created.
    required DateTime creationDate,

    /// `true` for a completed to-do, `false` otherwise.
    required bool completed,

    /// When `completed` is `true`, this is the date and time the to-do was marked as completed.
    DateTime? completionDate,
  }) = _ToDoEntity;
}

/// This enum represents the possible validation failures of a to-do.
enum ToDoValidationFailure {
  // To-dos should not have an empty title.
  titleIsEmpty,

  // To-dos should not have an empty description.
  descriptionIsEmpty,
}

/// This class will wrap a to-do that is being edited,
/// so it will hold the original value (so we can show a
/// "Discard changes" message if we try to exit the editor
/// without saving) and all validation errors.
@freezed
class EditingToDoEntity with _$EditingToDoEntity {
  const factory EditingToDoEntity({
    /// The current to-do being edited.
    required ToDoEntity toDo,

    /// The original unchanged to-do.
    required ToDoEntity originalToDo,

    /// A list of validation errors (or empty for no validation errors)
    required Iterable<ToDoValidationFailure> validationFailures,
  }) = _EditingToDoEntity;
}
