import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../domain/theme_domain.dart';
import '../presentation/events/theme_events.dart';
import '../repositories/in_memory_app_settings_repository.dart';

@immutable
abstract class BaseEnvironment extends Environment {
  const BaseEnvironment();

  @override
  Future<void> registerDependencies() async {
    registerDependency<IAppSettingsRepository>(
      (requires, platform) => const InMemoryAppSettingsRepository(),
    );

    registerDependency<ThemeDomain>(
      (requires, platform) => ThemeDomain(appSettingsRepository: requires<IAppSettingsRepository>()),
    );
  }

  @override
  void registerEventHandlers() {
    registerEventHandler<LoadTheme>((e) => ServiceProvider.required<ThemeDomain>().getThemeColor());
  }
}
