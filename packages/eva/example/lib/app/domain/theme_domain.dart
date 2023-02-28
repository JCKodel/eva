import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

const kBrightnessKey = "themeBrightness";

@immutable
class ThemeDomain implements IDomain {
  const ThemeDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  Future<ResponseOf<bool>> getThemeIsDark() async {
    final currentBrightness = await _appSettingsRepository.get(kBrightnessKey);

    return currentBrightness.map(success: (value) => ResponseOf.success(value == "D"));
  }

  Future<Response> setThemeIsDark(bool isDarkTheme) async {
    return _appSettingsRepository.set(kBrightnessKey, isDarkTheme ? "D" : "L");
  }
}
