import '../../eva/eva.dart';

@immutable
abstract class IAppSettingsRepository implements IRepository {
  Future<Response> set(String key, String value);
  Future<ResponseOf<String>> get(String key);
}
