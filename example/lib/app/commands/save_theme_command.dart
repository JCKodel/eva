import 'package:eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/to_do_theme_entity.dart';

/// This command will save the current theme brightness
@immutable
class SaveThemeCommand extends Command {
  const SaveThemeCommand({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  String toStringBody() {
    return "isDarkTheme: ${isDarkTheme}";
  }

  @override
  Stream<Event<ToDoThemeEntity>> handle(required, platform) async* {
    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.setThemeIsDark(isDarkTheme);

    // Notice that we don't have a yield waiting here (because we don't want
    // the UI to respond to this command using some CircularProgressIndicator)
    //
    // Also, we yield the same event used by `LoadThemeCommand`, since events are
    // not request --> response. We can dispatch any kind of event we want here
    // and the UI builders will respond accordingly.
    //
    // When saving to-dos, the behaviour is different, since we need to check some
    // things to decide if we want to navigate to the previous page or show some
    // error message, so, in this case, we are checking those things and dispatching
    // events directly from the UI (check the `_saveToDo` method on the `EditToDo`
    // widget for details)

    yield response.mapToEvent(success: (_) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
