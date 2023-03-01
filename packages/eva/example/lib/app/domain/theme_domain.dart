import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

const kBrightnessKey = "themeBrightness";

@immutable
class ThemeDomain implements IDomain {
  const ThemeDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  bool get canWatchThemeChanges => _appSettingsRepository.canWatch;

  Future<ResponseOf<bool>> getThemeIsDark() async {
    final currentBrightness = await _appSettingsRepository.get(kBrightnessKey);

    return currentBrightness.map(success: (value) => ResponseOf.success(value == "D"));
  }

  Future<Response> setThemeIsDark(bool isDarkTheme) async {
    return _appSettingsRepository.set(kBrightnessKey, isDarkTheme ? "D" : "L");
  }

  Future<ResponseOf<Stream<bool>>> setupThemeIsDarkWatcher() async {
    final watchStream = await _appSettingsRepository.watch(kBrightnessKey);

    return watchStream.map(
      success: (stream) => ResponseOf<Stream<bool>>.success(stream.map((value) => value == "D")),
    );
  }
}
