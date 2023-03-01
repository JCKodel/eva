import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/entities/to_do.dart';
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
    yield const Event<List<ToDo>>.waiting();

    if (_toDoDomain.canWatchToDoChanges) {
      // final watcherResponse = await _themeDomain.setupThemeIsDarkWatcher();

      // if (watcherResponse.type != ResponseType.success) {
      //   yield await _loadThemeIsDark(command);
      // } else {
      //   yield* watcherResponse.getValue().map((isDarkTheme) => Event<ToDoTheme>.success(ToDoTheme(isDarkTheme: isDarkTheme)));
      // }
    } else {
      yield await _loadToDos(command);
    }
  }

  Future<IEvent> _loadToDos(LoadToDosCommand command) async {
    final response = await _toDoDomain.listToDos(command.filter);

    return response.mapToEvent(
      success: (toDos) => toDos,
    );
  }
}
