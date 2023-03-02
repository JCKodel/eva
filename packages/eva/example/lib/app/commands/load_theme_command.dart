import '../../eva/eva.dart';
import '../domain/entities/to_do_theme_entity.dart';
import '../domain/settings_domain.dart';

@immutable
class LoadThemeCommand extends Command {
  const LoadThemeCommand();

  @override
  Stream<IEvent> handle(required, platformInfo) async* {
    yield const Event<ToDoThemeEntity>.waiting();

    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.getThemeIsDark();

    yield response.mapToEvent(success: (isDarkTheme) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
