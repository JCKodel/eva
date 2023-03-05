import 'package:eva/eva.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

/// STEP#7
/// This is the contract for the ToDo repository.
@immutable
abstract class IToDoRepository implements IRepository {
  /// List all available to dos from database and return `empty` if there is
  /// no to dos available, `failure` for exceptions or a `Iterable<ToDoEntity>`
  /// with the results found using the specified `ListToDosFilter`.
  Future<Response<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter);
  Future<Response<ToDoEntity>> getToDoById(int id);
  Future<Response<ToDoEntity>> saveToDo(ToDoEntity toDo);
  Future<Response<bool>> deleteToDoById(int toDoId);
}