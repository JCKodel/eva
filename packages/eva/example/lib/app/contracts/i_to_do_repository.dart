import '../../eva/eva.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

@immutable
abstract class IToDoRepository implements IRepository {
  Future<Response<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter);
  Future<Response<ToDoEntity>> getToDoById(int id);
  Future<Response<ToDoEntity>> saveToDo(ToDoEntity toDo);
  Future<Response<bool>> deleteToDoById(int toDoId);
}
