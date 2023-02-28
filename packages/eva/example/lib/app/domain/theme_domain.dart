import 'package:meta/meta.dart';

import '../../eva/domain/i_domain.dart';
import '../../eva/events/event.dart';
import '../contracts/i_app_settings_repository.dart';

const kColorKey = "color";

@immutable
class ThemeDomain implements IDomain {
  const ThemeDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  Future<EventOf<int>> getThemeColor() async {
    final currentColor = await _appSettingsRepository.get(kColorKey);

    return currentColor.map<int>(
      success: (value) => EventOf<int>.success(int.parse(value)),
    );
  }

  Future<Event> setThemeColor(int color) async {
    return _appSettingsRepository.set(kColorKey, color.toString());
  }
}
