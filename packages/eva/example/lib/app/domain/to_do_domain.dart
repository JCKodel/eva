import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';

import 'entities/to_do_entity.dart';

@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository}) : _toDoRepository = toDoRepository;

  final IToDoRepository _toDoRepository;

  bool get canWatchToDoChanges => _toDoRepository.canWatch;

  @override
  void initialize() {}

  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
    return _toDoRepository.listToDos(filter);
  }

  Future<ResponseOf<Stream<Iterable<ToDoEntity>>>> setupToDosWatcher() {
    return _toDoRepository.watch();
  }
}
