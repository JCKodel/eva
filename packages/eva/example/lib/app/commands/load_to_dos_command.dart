import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/entities/to_do_entity.dart';
import '../domain/to_do_domain.dart';

@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand({required this.filter});

  final ListToDosFilter filter;
}

@immutable
class LoadToDosCommandHandler extends CommandHandler<LoadToDosCommand> {
  const LoadToDosCommandHandler({required ToDoDomain toDoDomain}) : _toDoDomain = toDoDomain;

  final ToDoDomain _toDoDomain;

  @override
  Stream<IEvent> handle(LoadToDosCommand command) async* {
    yield const Event<List<ToDoEntity>>.waiting();
    yield await _loadToDos(command);
  }

  Future<IEvent> _loadToDos(LoadToDosCommand command) async {
    final response = await _toDoDomain.listToDos(command.filter);

    return response.mapToEvent(success: (toDos) => toDos);
  }
}
