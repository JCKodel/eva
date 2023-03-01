import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

@immutable
class SaveThemeCommand extends Command {
  const SaveThemeCommand({required this.isDarkTheme});

  final bool isDarkTheme;
}

@immutable
class SaveThemeCommandHandler extends CommandHandler<SaveThemeCommand> {
  const SaveThemeCommandHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handle(SaveThemeCommand command) async* {
    final saveResult = await _themeDomain.setThemeIsDark(command.isDarkTheme);

    yield saveResult.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: command.isDarkTheme));
  }
}
