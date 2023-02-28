import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

const kColorKey = "color";

@immutable
class ThemeDomain implements IDomain {
  const ThemeDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  Future<ResponseOf<int>> getThemeColor() async {
    final currentColor = await _appSettingsRepository.get(kColorKey);

    return currentColor.map(success: (value) => ResponseOf.success(int.parse(value)));
  }

  Future<Response> setThemeColor(int color) async {
    return _appSettingsRepository.set(kColorKey, color.toString());
  }
}
