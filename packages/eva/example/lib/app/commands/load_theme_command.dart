import '../../eva/eva.dart';
import '../domain/entities/to_do_theme_entity.dart';
import '../domain/settings_domain.dart';

@immutable
class LoadThemeCommand extends Command {
  const LoadThemeCommand();
}

@immutable
class LoadThemeCommandHandler extends CommandHandler<LoadThemeCommand> {
  const LoadThemeCommandHandler({required SettingsDomain settingsDomain}) : _settingsDomain = settingsDomain;

  final SettingsDomain _settingsDomain;

  @override
  Stream<IEvent> handle(LoadThemeCommand command) async* {
    yield const Event<ToDoThemeEntity>.waiting();
    yield await _loadThemeIsDark(command);
  }

  Future<IEvent> _loadThemeIsDark(LoadThemeCommand command) async {
    final response = await _settingsDomain.getThemeIsDark();

    return response.mapToEvent(success: (isDarkTheme) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
