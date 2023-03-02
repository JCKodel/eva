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
}
