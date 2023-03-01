import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../contracts/i_to_do_repository.dart';

@immutable
class SettingsDomain implements IDomain {
  const SettingsDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  bool get canWatchSetingsChanges => _appSettingsRepository.canWatch;

  static const kBrightnessKey = "themeBrightness";

  Future<ResponseOf<bool>> getThemeIsDark() async {
    final setting = await _appSettingsRepository.get(kBrightnessKey);

    return setting.map(success: (value) => ResponseOf.success(value == "D"));
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

  static const kListToDosFilter = "listToDosFilter";

  Future<ResponseOf<ListToDosFilter>> getListToDosFilter() async {
    final setting = await _appSettingsRepository.get(kListToDosFilter);

    return setting.map(
      success: (value) => ResponseOf.success(ListToDosFilter.values.firstWhere((v) => v.toString() == value)),
      empty: () => const ResponseOf.success(ListToDosFilter.all),
    );
  }

  Future<Response> setListToDosFilter(ListToDosFilter filter) async {
    return _appSettingsRepository.set(kListToDosFilter, filter.toString());
  }

  Future<ResponseOf<Stream<ListToDosFilter>>> setupListToDosFilterWatcher() async {
    final watchStream = await _appSettingsRepository.watch(kListToDosFilter);

    return watchStream.map(
      success: (stream) => ResponseOf<Stream<ListToDosFilter>>.success(
        stream.map(
          (value) => ListToDosFilter.values.firstWhere((v) => v.toString() == value),
        ),
      ),
    );
  }
}
