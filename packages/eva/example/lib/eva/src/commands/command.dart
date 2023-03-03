import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:meta/meta.dart';

import '../events/event.dart';

@immutable
abstract class Command {
  const Command();

  Stream<IEvent> handle(TService Function<TService>({String? key}) required, PlatformInfo platform);

  @override
  String toString() {
    final body = toStringBody();

    if (body == "") {
      return "[${runtimeType}]";
    }

    return "[${runtimeType}:${body}]";
  }

  String toStringBody() {
    return "";
  }
}
