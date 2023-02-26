import 'package:meta/meta.dart';

@immutable
abstract class Event {
  const Event();

  String get name => runtimeType.toString();
}
