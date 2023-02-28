import '../../../eva/eva.dart';
import '../../../eva/src/events/event_handler.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

@immutable
class LoadTheme {
  const LoadTheme();
}

@immutable
class LoadThemeEventHandler extends EventHandler {
  const LoadThemeEventHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handle<TInput>(Event<TInput> event) async* {
    yield const Event<ToDoTheme>.waiting();

    final themeIsDark = await _themeDomain.getThemeIsDark();

    yield themeIsDark.mapToEvent(
      success: (isDarkTheme) => ToDoTheme(isDarkTheme: isDarkTheme),
    );
  }
}
