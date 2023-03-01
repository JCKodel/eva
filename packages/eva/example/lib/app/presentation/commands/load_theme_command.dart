import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

@immutable
class LoadThemeCommand extends Command {
  const LoadThemeCommand();
}

@immutable
class LoadThemeCommandHandler extends CommandHandler<LoadThemeCommand> {
  const LoadThemeCommandHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handle(LoadThemeCommand command) async* {
    yield const Event<ToDoTheme>.waiting();

    final themeIsDark = await _themeDomain.getThemeIsDark();

    yield themeIsDark.mapToEvent(
      success: (isDarkTheme) => ToDoTheme(isDarkTheme: isDarkTheme),
    );
  }
}
