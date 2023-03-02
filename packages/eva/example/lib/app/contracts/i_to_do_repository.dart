import '../../eva/eva.dart';
import '../domain/entities/to_do_entity.dart';

enum ListToDosFilter {
  all,
  completedOnly,
  uncompletedOnly,
}

@immutable
abstract class IToDoRepository implements IRepository {
  bool get canWatch;
  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter);
  Future<ResponseOf<Stream<Iterable<ToDoEntity>>>> watch();
}
