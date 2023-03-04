import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

/// This is a fake implementation of `IAppSettingsRepository`
/// suited for test environments (although you could always use
/// the mockito package for that)
@immutable
class InMemoryAppSettingsRepository implements IAppSettingsRepository {
  const InMemoryAppSettingsRepository();

  static final _settings = <String, String>{};

  @override
  Future<void> initialize() async {}

  @override
  Future<Response<String>> get(String key) async {
    return Response.success(_settings[key]);
  }

  @override
  Future<Response<String>> set(String key, String value) async {
    _settings[key] = value;

    return Response.success(value);
  }
}
