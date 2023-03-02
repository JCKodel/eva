import '../../eva/eva.dart';
import '../domain/entities/to_do.dart';

enum ListToDosFilter {
  all,
  completedOnly,
  uncompletedOnly,
}

@immutable
abstract class IToDoRepository implements IRepository {
  bool get canWatch;
  Future<ResponseOf<Iterable<ToDo>>> listToDos(ListToDosFilter filter);
  Future<ResponseOf<Stream<Iterable<ToDo>>>> watch();
}
