import 'package:meta/meta.dart';

import '../../eva/events/event.dart';
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
  Future<EventOf<String>> get(String key) async {
    return EventOf<String>.success(_settings[key]);
  }

  @override
  Future<Event> set(String key, String value) async {
    _settings[key] = value;

    return const Event.empty();
  }

  @override
  Future<EventOf<Stream<String>>> watch(String key) async {
    return EventOf<Stream<String>>.failure(UnimplementedError());
  }
}
