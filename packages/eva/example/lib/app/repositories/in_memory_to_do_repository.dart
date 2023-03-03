import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

@immutable
class InMemoryToDoRepository implements IToDoRepository {
  const InMemoryToDoRepository();

  static final _toDos = <int, ToDoEntity>{
    1: ToDoEntity(
      id: 1,
      title: "First To Do",
      description: "You are using the in memory to do repository",
      completed: false,
      creationDate: DateTime.now(),
    ),
  };

  @override
  Future<void> initialize() async {}

  @override
  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
    switch (filter) {
      case ListToDosFilter.all:
        return ResponseOf.success(_toDos.values);
      case ListToDosFilter.completedOnly:
        return ResponseOf.success(_toDos.values.where((toDo) => toDo.completed));
      case ListToDosFilter.uncompletedOnly:
        return ResponseOf.success(_toDos.values.where((toDo) => toDo.completed == false));
    }
  }

  @override
  Future<ResponseOf<ToDoEntity>> getToDoById(int id) async {
    final toDo = _toDos[id];

    if (toDo == null) {
      return const ResponseOf.empty();
    }

    return ResponseOf.success(toDo);
  }

  @override
  Future<Response> saveToDo(ToDoEntity toDo) async {
    if (toDo.id == null) {
      final id = _toDos.length + 1;

      _toDos[id] = toDo.copyWith(id: id);
    } else {
      _toDos[toDo.id!] = toDo;
    }

    return const Response.success();
  }
}
