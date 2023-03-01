import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';

@immutable
class ToDoDomain implements IDomain {
  const ToDoDomain({required IToDoRepository toDoRepository}) : _toDoRepository = toDoRepository;

  final IToDoRepository _toDoRepository;

  bool get canWatchToDoChanges => _toDoRepository.canWatch;

  @override
  void initialize() {}
}
