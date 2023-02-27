import 'package:meta/meta.dart';

import '../../eva/contracts/i_repository.dart';
import '../../eva/responses/response.dart';

@immutable
abstract class IAppSettingsRepository implements IRepository {
  bool get canWatch;
  Future<Response<void>> set(String key, String value);
  Future<Response<String>> get(String key);
  Future<Response<Stream<String>>> watch(String key);
}
