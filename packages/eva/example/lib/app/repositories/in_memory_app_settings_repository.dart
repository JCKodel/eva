import '../../eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';

@immutable
class InMemoryAppSettingsRepository implements IAppSettingsRepository {
  const InMemoryAppSettingsRepository();

  static const Map<String, String> _settings = <String, String>{};

  @override
  void initialize() {}

  @override
  bool get canWatch => false;

  @override
  Future<ResponseOf<String>> get(String key) async {
    return ResponseOf<String>.success(_settings[key]);
  }

  @override
  Future<Response> set(String key, String value) async {
    _settings[key] = value;

    return const Response.empty();
  }

  @override
  Future<ResponseOf<Stream<String>>> watch(String key) async {
    return ResponseOf<Stream<String>>.failure(UnimplementedError());
  }
}
