import '../../eva/eva.dart';

@immutable
abstract class IAppSettingsRepository implements IRepository {
  bool get canWatch;
  Future<Response> set(String key, String value);
  Future<ResponseOf<String>> get(String key);
  Future<ResponseOf<Stream<String>>> watch(String key);
}
