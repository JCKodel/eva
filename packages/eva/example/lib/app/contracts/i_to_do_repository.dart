import '../../eva/eva.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

@immutable
abstract class IToDoRepository implements IRepository {
  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter);
}
