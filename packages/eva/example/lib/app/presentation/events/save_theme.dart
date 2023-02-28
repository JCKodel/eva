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
  Stream<IEvent> handle<TInput>(Event<TInput> event) async* {
    yield* event.maybeMatch(
      success: (event) => _setTheme(event as SuccessEvent<SaveTheme>),
      otherwise: (e) => throw e,
    );
  }

  Stream<IEvent> _setTheme(SuccessEvent<SaveTheme> event) async* {
    final saveResult = await _themeDomain.setThemeIsDark(event.value.isDarkTheme);

    yield saveResult.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: event.value.isDarkTheme));
  }
}
