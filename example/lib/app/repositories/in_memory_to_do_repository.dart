import 'package:eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

/// This is a fake implementation of `IToDoRepository`
/// suited for test environments (although you could always use
/// the mockito package for that)
@immutable
class InMemoryToDoRepository implements IToDoRepository {
  const InMemoryToDoRepository();

  static final _toDos = <int, ToDoEntity>{
    1: ToDoEntity(
      id: 1,
      title: "First To Do",
      description: "You are using the in-memory to do repository",
      completed: false,
      creationDate: DateTime.now(),
    ),
  };

  @override
  Future<Response<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
    switch (filter) {
      case ListToDosFilter.all:
        return Response.success(_toDos.values);
      case ListToDosFilter.completedOnly:
        return Response.success(_toDos.values.where((toDo) => toDo.completed));
      case ListToDosFilter.uncompletedOnly:
        return Response.success(_toDos.values.where((toDo) => toDo.completed == false));
    }
  }

  @override
  Future<Response<ToDoEntity>> getToDoById(int id) async {
    final toDo = _toDos[id];

    if (toDo == null) {
      return const Response.empty();
    }

    return Response.success(toDo);
  }

  @override
  Future<Response<ToDoEntity>> saveToDo(ToDoEntity toDo) async {
    if (toDo.id == null) {
      final id = _toDos.length + 1;

      return Response.success(_toDos[id] = toDo.copyWith(id: id));
    }

    return Response.success(_toDos[toDo.id!] = toDo);
  }

  @override
  Future<Response<bool>> deleteToDoById(int toDoId) async {
    if (_toDos.containsKey(toDoId) == false) {
      return const Response.success(false);
    }

    _toDos.remove(toDoId);

    return const Response.success(true);
  }
}
