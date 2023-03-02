import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

@immutable
class InMemoryAppSettingsRepository implements IAppSettingsRepository {
  const InMemoryAppSettingsRepository();

  static final _settings = <String, String>{};

  @override
  Future<void> initialize() async {}

  @override
  Future<ResponseOf<String>> get(String key) async {
    return ResponseOf.success(_settings[key]);
  }

  @override
  Future<Response> set(String key, String value) async {
    _settings[key] = value;

    return const Response.success();
  }
}
