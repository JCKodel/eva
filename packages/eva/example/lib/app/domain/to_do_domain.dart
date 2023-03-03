import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository}) : _toDoRepository = toDoRepository;

  final IToDoRepository _toDoRepository;

  @override
  void initialize() {}

  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
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
}
