import '../../eva/eva.dart';
import '../domain/entities/to_do_theme_entity.dart';
import '../domain/settings_domain.dart';

@immutable
class SaveThemeCommand extends Command {
  const SaveThemeCommand({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  Stream<IEvent> handle(required, platformInfo) async* {
    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.setThemeIsDark(isDarkTheme);

    yield response.mapToEvent(success: (_) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
