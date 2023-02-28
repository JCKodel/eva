import '../../eva.dart';

@immutable
abstract class EventHandler {
  const EventHandler();

  Stream<IEvent> handle<TInput>(Event<TInput> event);
}
