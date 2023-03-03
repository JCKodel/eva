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

  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos() async {
    final filterResponse = await _settingsDomain.getListToDosFilter();

    if (filterResponse.type != ResponseType.success) {
      return filterResponse.toResponseOf();
    }

    final filter = filterResponse.getValue();
    final response = await _toDoRepository.listToDos(filter);

    return response.map(
      success: (value) => value.isEmpty ? const ResponseOf<Iterable<ToDoEntity>>.empty() : ResponseOf<Iterable<ToDoEntity>>.success(value),
    );
  }

  Future<ResponseOf<EditingToDoEntity>> startEditingToDo(int? toDoId) async {
    if (toDoId == null) {
      final emptyToDo = ToDoEntity(
        title: "",
        description: "",
        creationDate: DateTime.now(),
        completed: false,
      );

      return validateToDo(emptyToDo);
    }

    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    return currentToDo.map(
      success: (toDo) => validateToDo(toDo),
    );
  }

  ResponseOf<EditingToDoEntity> validateToDo(ToDoEntity toDo) {
    final validationFailures = <ToDoValidationFailure>[];

    if (toDo.title == "") {
      validationFailures.add(ToDoValidationFailure.titleIsEmpty);
    }

    if (toDo.description == "") {
      validationFailures.add(ToDoValidationFailure.descriptionIsEmpty);
    }

    return ResponseOf.success(
      EditingToDoEntity(
        toDo: toDo,
        validationFailures: validationFailures,
      ),
    );
  }

  Future<ResponseOf<SavingToDoEntity>> saveEditingToDo(EditingToDoEntity editingToDo) async {
    final validationResult = validateToDo(editingToDo.toDo).getValue();

    if (validationResult.validationFailures.isNotEmpty) {
      return ResponseOf.failure(validationResult.validationFailures);
    }

    final response = await _toDoRepository.saveToDo(editingToDo.toDo);

    return response.toResponseOf<SavingToDoEntity>(success: () => SavingToDoEntity(toDo: editingToDo.toDo));
  }

  Future<ResponseOf<ToDoEntity>> setToDoCompletedCommand({required int toDoId, required bool completed}) async {
    final currentToDo = await _toDoRepository.getToDoById(toDoId);

    return currentToDo.mapAsync(
      success: (toDo) async {
        if (toDo.completed == completed) {
          return ResponseOf.success(toDo);
        }

        final response = await _toDoRepository.saveToDo(toDo.copyWith(completed: completed, completionDate: DateTime.now()));

        return response.toResponseOf();
      },
    );
  }
}
