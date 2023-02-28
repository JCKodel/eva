import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

@immutable
class SaveTheme {
  const SaveTheme({required this.isDarkTheme});

  final bool isDarkTheme;
}

@immutable
class SaveThemeEventHandler extends EventHandler {
  const SaveThemeEventHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handle<TInput>(TInput eventState) async* {
    eventState as SaveTheme;

    final saveResult = await _themeDomain.setThemeIsDark(eventState.isDarkTheme);

    yield saveResult.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: eventState.isDarkTheme));
  }
}
