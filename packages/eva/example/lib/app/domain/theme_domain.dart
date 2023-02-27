import 'package:meta/meta.dart';

import '../../eva/domain/i_domain.dart';
import '../../eva/responses/response.dart';
import '../contracts/i_app_settings_repository.dart';

const kColorKey = "color";

@immutable
class ThemeDomain implements IDomain {
  const ThemeDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  @override
  void initialize() {}

  Future<Response<int>> getThemeColor() async {
    final currentColor = await _appSettingsRepository.get(kColorKey);

    return currentColor.map(
      success: (value) => Response.success(int.parse(value)),
    );
  }

  Future<Response<void>> setThemeColor(int color) async {
    return _appSettingsRepository.set(kColorKey, color.toString());
  }
}
