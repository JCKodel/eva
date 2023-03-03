import '../../eva/eva.dart';

@immutable
abstract class IAppSettingsRepository implements IRepository {
  Future<Response<String>> set(String key, String value);
  Future<Response<String>> get(String key);
}
