import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';

import 'entities/to_do.dart';

@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository}) : _toDoRepository = toDoRepository;

  final IToDoRepository _toDoRepository;

  bool get canWatchToDoChanges => _toDoRepository.canWatch;

  @override
  void initialize() {}

  Future<ResponseOf<Iterable<ToDo>>> listToDos(ListToDosFilter filter) async {
    return _toDoRepository.listToDos(filter);
  }

  Future<ResponseOf<Stream<Iterable<ToDo>>>> setupToDosWatcher() {
    return _toDoRepository.watch();
  }
}
