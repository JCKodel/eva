import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

@immutable
class SaveTheme {
  const SaveTheme({required this.isDarkTheme});

  final bool isDarkTheme;
}

@immutable
class SaveThemeEventHandler extends EventHandler<SaveTheme> {
  const SaveThemeEventHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handleSuccess(SuccessEvent<SaveTheme> event) async* {
    final saveResult = await _themeDomain.setThemeIsDark(event.value.isDarkTheme);

    yield saveResult.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: event.value.isDarkTheme));
  }
}
