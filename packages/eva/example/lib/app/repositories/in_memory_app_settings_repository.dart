import 'package:meta/meta.dart';

import '../../eva/responses/response.dart';
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
  Future<Response<String>> get(String key) async {
    return Response.success(_settings[key]);
  }

  @override
  Future<Response<void>> set(String key, String value) async {
    _settings[key] = value;

    return const Response.empty();
  }

  @override
  Future<Response<Stream<String>>> watch(String key) async {
    return Response.failure(UnimplementedError());
  }
}
