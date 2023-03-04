import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../entities/to_do_entity.dart';

import 'settings_domain.dart';

/// STEP#6
/// Handles all business logic related to to-dos, except the ones that are related to app settings.
@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository, required SettingsDomain settingsDomain})
      : _toDoRepository = toDoRepository,
        _settingsDomain = settingsDomain;

  final IToDoRepository _toDoRepository;
  final SettingsDomain _settingsDomain;

  @override
  void initialize() {}

  /// Returns a list of all to-dos, based on the saved filter.
  Future<Response<Iterable<ToDoEntity>>> listToDos() async {
    // Notice that we are asking the filter to the SettingsDomain, because
    // it knows how to handle the default case.
    //
    // Don't repeat business logic in multiple places, instead, inject another
    // domain and call it whenever you need to.
    final filterResponse = await _settingsDomain.getListToDosFilter();

    // If the `getListToDosFilter` returned empty or failure, it will be returned
    // here without any changes. We just need to handle the success case:
    return filterResponse.mapAsync(
      // `filter` is the current filter returned by the `getListToDosFilter` above
      success: (filter) async {
        // Now that we know what filter to use, we can list our to-dos:
        final response = await _toDoRepository.listToDos(filter);

        // Since ordering and filtering are much better handled by databases,
        // we won't build that here. It's a domain violation (because this method
        // SHOULD return a filtered list of to-dos), but it would be impractical
        // to filter a big list here. Sometimes rules must be bent.

        return response.map(
          // An empty list is an empty result, and we're not sure if the repository
          // will actually consider this rule, so we are emphasizing it here:
          // if the list of to-dos is empty, we return an empty result (because in the UI,
          // an empty result will show a different widget than the list)
          success: (value) => value.isEmpty ? const Response<Iterable<ToDoEntity>>.empty() : Response<Iterable<ToDoEntity>>.success(value),
        );
      },
    );
  }

  // This will start the edition of a to-do. It will store the old value
  // and wrap the editing toDo, the original toDo and all validation errors
  // inside a `EditingToDoEntity`. This will allow us to check if the to do
  // was modified in the edit/new to do page (to handle WillPopScope) and
  // also will validate the to-do entity whenever it changes.
  Future<Response<EditingToDoEntity>> startEditingToDo(int? toDoId) async {
    if (toDoId == null) {
      // If the to-do id is null, then we are using the [+] button to create a new one.
      final emptyToDo = ToDoEntity(
        title: "",
        description: "",
        creationDate: DateTime.now(),
        completed: false,
      );

      // Since this code is the same in this method, we will extract it
      // to a function to not repeat ourselves.
      return _wrapToDo(emptyToDo);
    }

    // We get here when the `toDoId` is not null, so we need to actually
    // load the specified to-do from the database before editing it.

    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    // Since the arguments required by `success` matches the arguments
    // required by `_wrapToDo`, we can just use this shortcut instead of
    // writing `success: (toDo) => _wrapToDo(toDo)`
    return currentToDo.map(success: _wrapToDo);
  }

  /// This is a simple DRY (Don't Repeat Yourself) function to
  /// wrap a to-do inside an `EditingToDoEntity`.
  Response<EditingToDoEntity> _wrapToDo(ToDoEntity toDo) {
    return Response.success(
      EditingToDoEntity(
        originalToDo: toDo.copyWith(),
        toDo: toDo,
        // This initial validation will add all errors an empty to-do has,
        // so our UI will show them before you start to edit the new to-do.
        validationFailures: validateToDo(toDo),
      ),
    );
  }

  /// Validates a to-do and returns a list of failures or an empty list if
  /// all is ok.
  Iterable<ToDoValidationFailure> validateToDo(ToDoEntity toDo) {
    final validationFailures = <ToDoValidationFailure>[];

    // To-dos cannot have an empty title.
    if (toDo.title == "") {
      validationFailures.add(ToDoValidationFailure.titleIsEmpty);
    }

    // To-dos cannot have an empty description.
    if (toDo.description == "") {
      validationFailures.add(ToDoValidationFailure.descriptionIsEmpty);
    }

    return validationFailures;
  }

  /// Saves an editing to-do.
  Future<Response<ToDoEntity>> saveEditingToDo(EditingToDoEntity editingToDo) async {
    // Best practice: Never trust the UI or the call chain: validate again before saving.
    final validationFailures = validateToDo(editingToDo.toDo);

    // The UI will have to check for this specific failure
    if (validationFailures.isNotEmpty) {
      return Response.failure(validationFailures);
    }

    late Response<ToDoEntity> response;

    if (editingToDo.toDo.id == null && editingToDo.toDo.completed) {
      // Best practice: We can't trust the repository to actually set the
      // `completionDate` whenever the to-do is completed, so we are doing
      // this here (as well?)
      response = await _toDoRepository.saveToDo(editingToDo.toDo.copyWith(completionDate: DateTime.now()));
    } else {
      response = await _toDoRepository.saveToDo(editingToDo.toDo);
    }

    return response;
  }

  /// Since the UI allows a to-do to be marked as completed/uncomplete without actually editing it,
  /// we handle that here
  Future<Response<ToDoEntity>> setToDoCompleted({required int toDoId, required bool completed}) async {
    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    return currentToDo.mapAsync(
      success: (toDo) async {
        if (toDo.completed == completed) {
          return Response.success(toDo);
        }

        // Again, don't trust the repository to set `completionDate` to now
        return _toDoRepository.saveToDo(
          toDo.copyWith(
            completed: completed,
            completionDate: completed ? DateTime.now() : null,
          ),
        );
      },
    );
  }

  /// Deletes a to-do, by its id.
  Future<Response<int>> deleteToDo({required int toDoId}) async {
    final response = await _toDoRepository.deleteToDoById(toDoId);

    // Again, we don't care about the result value (or even if the
    // to-do was deleted before and this is a non-op operation
    // because of it (deleting something that doesn't exists)),
    // since the UI will refresh after this change (or at least
    // we trust the UI business logic (`Command`) will do this)
    return response.map(success: (_) => Response.success(toDoId));
  }
}
