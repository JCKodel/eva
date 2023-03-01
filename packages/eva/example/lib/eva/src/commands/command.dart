import 'package:meta/meta.dart';

@immutable
abstract class Command {
  const Command();

  @override
  String toString() {
    return "[${runtimeType}]";
  }
}
