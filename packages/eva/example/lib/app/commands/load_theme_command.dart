import '../../eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/to_do_theme_entity.dart';

@immutable
class LoadThemeCommand extends Command {
  const LoadThemeCommand();

  @override
  Stream<Event<ToDoThemeEntity>> handle(required, platform) async* {
    yield const Event<ToDoThemeEntity>.waiting();

    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.getThemeIsDark();

    yield response.mapToEvent(success: (isDarkTheme) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
