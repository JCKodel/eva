import '../../eva/eva.dart';
import '../domain/entities/to_do_theme.dart';
import '../domain/settings_domain.dart';

@immutable
class SaveThemeCommand extends Command {
  const SaveThemeCommand({required this.isDarkTheme});

  final bool isDarkTheme;
}

@immutable
class SaveThemeCommandHandler extends CommandHandler<SaveThemeCommand> {
  const SaveThemeCommandHandler({required SettingsDomain settingsDomain}) : _settingsDomain = settingsDomain;

  final SettingsDomain _settingsDomain;

  @override
  Stream<IEvent> handle(SaveThemeCommand command) async* {
    final response = await _settingsDomain.setThemeIsDark(command.isDarkTheme);

    if (_settingsDomain.canWatchSetingsChanges == false) {
      yield response.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: command.isDarkTheme));
    }
  }
}
