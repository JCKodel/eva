import '../../eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/to_do_theme_entity.dart';

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

    yield response.mapToEvent(success: (_) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
