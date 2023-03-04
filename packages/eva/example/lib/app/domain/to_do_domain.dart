import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../entities/to_do_entity.dart';

import 'settings_domain.dart';

@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository, required SettingsDomain settingsDomain})
      : _toDoRepository = toDoRepository,
        _settingsDomain = settingsDomain;

  final IToDoRepository _toDoRepository;
  final SettingsDomain _settingsDomain;

  @override
  void initialize() {}

  Future<Response<Iterable<ToDoEntity>>> listToDos() async {
    final filterResponse = await _settingsDomain.getListToDosFilter();

    return filterResponse.mapAsync(
      success: (filter) async {
        final response = await _toDoRepository.listToDos(filter);

        return response.map(
          success: (value) => value.isEmpty ? const Response<Iterable<ToDoEntity>>.empty() : Response<Iterable<ToDoEntity>>.success(value),
        );
      },
    );
  }

  Future<Response<EditingToDoEntity>> startEditingToDo(int? toDoId) async {
    if (toDoId == null) {
      final emptyToDo = ToDoEntity(
        title: "",
        description: "",
        creationDate: DateTime.now(),
        completed: false,
      );

      return Response.success(
        EditingToDoEntity(
          originalToDo: emptyToDo.copyWith(),
          toDo: emptyToDo,
          validationFailures: validateToDo(emptyToDo),
        ),
      );
    }

    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    return currentToDo.map(
      success: (toDo) => Response.success(
        EditingToDoEntity(
          originalToDo: toDo.copyWith(),
          toDo: toDo,
          validationFailures: validateToDo(toDo),
        ),
      ),
    );
  }

  Iterable<ToDoValidationFailure> validateToDo(ToDoEntity toDo) {
    final validationFailures = <ToDoValidationFailure>[];

    if (toDo.title == "") {
      validationFailures.add(ToDoValidationFailure.titleIsEmpty);
    }

    if (toDo.description == "") {
      validationFailures.add(ToDoValidationFailure.descriptionIsEmpty);
    }

    return validationFailures;
  }

  Future<Response<ToDoEntity>> saveEditingToDo(EditingToDoEntity editingToDo) async {
    final validationFailures = validateToDo(editingToDo.toDo);

    if (validationFailures.isNotEmpty) {
      return Response.failure(validationFailures);
    }

    late Response<ToDoEntity> response;

    if (editingToDo.toDo.id == null && editingToDo.toDo.completed) {
      response = await _toDoRepository.saveToDo(editingToDo.toDo.copyWith(completionDate: DateTime.now()));
    } else {
      response = await _toDoRepository.saveToDo(editingToDo.toDo);
    }

    return response;
  }

  Future<Response<ToDoEntity>> setToDoCompleted({required int toDoId, required bool completed}) async {
    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    return currentToDo.mapAsync(
      success: (toDo) async {
        if (toDo.completed == completed) {
          return Response.success(toDo);
        }

        return _toDoRepository.saveToDo(toDo.copyWith(completed: completed, completionDate: DateTime.now()));
      },
    );
  }

  Future<Response<ToDoEntity>> loadToDo({required int toDoId}) async {
    return _toDoRepository.getToDoById(toDoId);
  }

  Future<Response<int>> deleteToDo({required int toDoId}) async {
    final response = await _toDoRepository.deleteToDoById(toDoId);

    return response.map(success: (_) => Response.success(toDoId));
  }
}
