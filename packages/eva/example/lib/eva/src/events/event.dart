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
  const factory Event(T value) = SuccessEvent._;
  const Event._();
  const factory Event.empty() = EmptyEvent._;
  const factory Event.waiting() = WaitingEvent._;
  const factory Event.failure(Object exception) = FailureEvent._;
  const factory Event.success(T value) = SuccessEvent._;

  @override
  String toString() => "{Event<${T}>}";

  TResponse match<TResponse>({
    required TResponse Function(FailureEvent<T> event) failure,
    required TResponse Function(EmptyEvent<T> event) empty,
    required TResponse Function(WaitingEvent<T> event) waiting,
    required TResponse Function(SuccessEvent<T> value) success,
  }) {
    if (this is EmptyEvent<T>) {
      return empty(this as EmptyEvent<T>);
    }

    if (this is WaitingEvent<T>) {
      return waiting(this as WaitingEvent<T>);
    }

    if (this is FailureEvent<T>) {
      return failure(this as FailureEvent<T>);
    }

    if (this is SuccessEvent<T>) {
      return success(this as SuccessEvent<T>);
    }

    throw UnsupportedError("Event is of unexpected `${runtimeType} type");
  }

  TResponse maybeMatch<TResponse>({
    required TResponse Function(Event<T> event) otherwise,
    TResponse Function(FailureEvent<T> event)? failure,
    TResponse Function(EmptyEvent<T> event)? empty,
    TResponse Function(WaitingEvent<T> event)? waiting,
    TResponse Function(SuccessEvent<T> event)? success,
  }) {
    if (this is EmptyEvent<T>) {
      return empty == null ? otherwise(this) : empty(this as EmptyEvent<T>);
    }

    if (this is WaitingEvent<T>) {
      return waiting == null ? otherwise(this) : waiting(this as WaitingEvent<T>);
    }

    if (this is FailureEvent<T>) {
      return failure == null ? otherwise(this) : failure(this as FailureEvent<T>);
    }

    if (this is SuccessEvent<T>) {
      return success == null ? otherwise(this) : success(this as SuccessEvent<T>);
    }

    return otherwise(this);
  }
}

@immutable
@sealed
class EmptyEvent<T> extends Event<T> implements IEmptyEvent {
  const EmptyEvent._() : super._();

  @override
  String toString() => "{EmptyEvent<${T}>}";
}

@immutable
@sealed
class WaitingEvent<T> extends Event<T> implements IWaitingEvent {
  const WaitingEvent._() : super._();

  @override
  String toString() => "{WaitingEvent<${T}>}";
}

@immutable
@sealed
class FailureEvent<T> extends Event<T> implements IFailureEvent {
  const FailureEvent._(Object exception)
      : _exception = exception,
        super._();

  final Object _exception;

  @override
  Object get exception => _exception;

  @override
  String toString() => "{FailureEvent<${T}>:${_exception.runtimeType}:${_exception}}";
}

@immutable
@sealed
class SuccessEvent<T> extends Event<T> implements ISuccessEvent {
  const SuccessEvent._(T value)
      : _value = value,
        super._();

  final T _value;

  @override
  T get value => _value;

  @override
  String toString() => "{SuccessEvent<${T}>:${value}}";
}

@immutable
class EvaReadyEvent {
  const EvaReadyEvent();
}

@immutable
class UnexpectedExceptionEvent {
  const UnexpectedExceptionEvent(this.exception);

  final Object exception;
}
