import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import '../../eva.dart';

@immutable
abstract class Command {
  const Command();

  Stream<IEvent> handle(RequiredFactory required, PlatformInfo platform);

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
