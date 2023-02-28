import 'package:meta/meta.dart';

@immutable
abstract class IEvent {}

@immutable
abstract class IEmptyEvent implements IEvent {}

@immutable
abstract class IWaitingEvent implements IEvent {}

@immutable
abstract class IFailureEvent implements IEvent {
  Object get exception;
}

@immutable
abstract class ISuccessEvent implements IEvent {
  dynamic get value;
}

@immutable
@sealed
class Event<T> implements IEvent {
  const Event();
  const factory Event.empty() = EmptyEvent;
  const factory Event.waiting() = WaitingEvent;
  const factory Event.failure(Object exception) = FailureEvent;
  const factory Event.success(T value) = SuccessEvent;

  @override
  String toString() => "{Event<${T}>}";
}

@immutable
@sealed
class EmptyEvent<T> extends Event<T> implements IEmptyEvent {
  const EmptyEvent();

  @override
  String toString() => "{EmptyEvent<${T}>}";
}

@immutable
@sealed
class WaitingEvent<T> extends Event<T> implements IWaitingEvent {
  const WaitingEvent();

  @override
  String toString() => "{WaitingEvent<${T}>}";
}

@immutable
@sealed
class FailureEvent<T> extends Event<T> implements IFailureEvent {
  const FailureEvent(Object exception) : _exception = exception;

  final Object _exception;

  @override
  Object get exception => _exception;

  @override
  String toString() => "{FailureEvent<${T}>:${_exception.runtimeType}}";
}

@immutable
@sealed
class SuccessEvent<T> extends Event<T> implements ISuccessEvent {
  const SuccessEvent(T value) : _value = value;

  final T _value;

  @override
  T get value => _value;

  @override
  String toString() => "{SuccessEvent<${T}>}";
}
