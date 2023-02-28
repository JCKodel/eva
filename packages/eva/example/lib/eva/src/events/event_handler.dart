import '../../eva.dart';

@immutable
abstract class IEventHandler {}

@immutable
abstract class EventHandler<T> implements IEventHandler {
  const EventHandler();

  Stream<IEvent> handleSuccess(SuccessEvent<T> event);

  Stream<IEvent> handleFailure(FailureEvent<T> event) {
    throw event.exception;
  }

  Stream<IEvent> handleEmpty(EmptyEvent<T> event) async* {
    Log.warn(() => "${event} is not handled because `${runtimeType} don't override handleEmpty");
    Log.verbose(() => event.toString());
  }

  Stream<IEvent> handleWaiting(WaitingEvent<T> event) async* {
    Log.warn(() => "${event} is not handled because `${runtimeType} don't override handleWaiting");
    Log.verbose(() => event.toString());
  }
}
