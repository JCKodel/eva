import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../entities/list_to_dos_filter.dart';

@immutable
class SettingsDomain implements IDomain {
  const SettingsDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  static const kBrightnessKey = "themeBrightness";

  Future<Response<bool>> getThemeIsDark() async {
    final setting = await _appSettingsRepository.get(kBrightnessKey);

    return setting.map(success: (value) => Response.success(value == "D"));
  }

  Future<Response<bool>> setThemeIsDark(bool isDarkTheme) async {
    final response = await _appSettingsRepository.set(kBrightnessKey, isDarkTheme ? "D" : "L");

    return response.map(success: (value) => Response.success(isDarkTheme));
  }

  static const kListToDosFilter = "listToDosFilter";

  Future<Response<ListToDosFilter>> getListToDosFilter() async {
    final setting = await _appSettingsRepository.get(kListToDosFilter);

    return setting.map(
      success: (value) => Response.success(ListToDosFilter.values.firstWhere((v) => v.toString() == value)),
      empty: () => const Response.success(ListToDosFilter.all),
    );
  }

  Future<Response<ListToDosFilter>> setListToDosFilter(ListToDosFilter filter) async {
    final response = await _appSettingsRepository.set(kListToDosFilter, filter.toString());

    return response.map(success: (value) => Response.success(filter));
  }
}
