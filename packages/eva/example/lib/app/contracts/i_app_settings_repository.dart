import 'package:meta/meta.dart';

import '../../eva/contracts/i_repository.dart';
import '../../eva/events/event.dart';

@immutable
abstract class IAppSettingsRepository implements IRepository {
  bool get canWatch;
  Future<Event> set(String key, String value);
  Future<EventOf<String>> get(String key);
  Future<EventOf<Stream<String>>> watch(String key);
}
