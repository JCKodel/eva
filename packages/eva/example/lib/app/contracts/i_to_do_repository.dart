import '../../eva/eva.dart';
import '../domain/entities/to_do_entity.dart';

enum ListToDosFilter {
  all,
  completedOnly,
  uncompletedOnly,
}

@immutable
abstract class IToDoRepository implements IRepository {
  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter);
}
