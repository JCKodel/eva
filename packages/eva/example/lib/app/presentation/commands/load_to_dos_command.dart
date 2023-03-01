import '../../../eva/eva.dart';
import '../../domain/entities/to_do.dart';
import '../../domain/to_do_domain.dart';

@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand();
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
      // yield await _loadThemeIsDark(command);
    }
  }

  // Future<IEvent> _loadThemeIsDark(LoadToDosCommand command) async {
  //   // final themeIsDark = await _themeDomain.getThemeIsDark();

  //   // return themeIsDark.mapToEvent(
  //   //   success: (isDarkTheme) => ToDo(isDarkTheme: isDarkTheme),
  //   // );
  // }
}
