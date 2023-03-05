import 'package:meta/meta.dart';

/// Represents the base level of an event
@immutable
abstract class IEvent {}

/// Represents an empty event
@immutable
abstract class IEmptyEvent implements IEvent {}

/// Represents a waiting event
@immutable
abstract class IWaitingEvent implements IEvent {}

/// Represents a failure event
@immutable
abstract class IFailureEvent implements IEvent {
  Object get exception;
}

/// Represents a success event
@immutable
abstract class ISuccessEvent implements IEvent {
  dynamic get value;
}

/// Events are classes that hold a value (success), no value (empty),
/// a failure (exception) or a waiting state.
///
/// They are similar to `Response<T>`, with an extra state: waiting
@immutable
@sealed
class Event<T> implements IEvent {
  const factory Event(T value) = SuccessEvent._;
  const Event._();

  /// Creates a new empty event
  const factory Event.empty() = EmptyEvent._;

  /// Creates a new waiting event
  const factory Event.waiting() = WaitingEvent._;

  /// Creates a new failure event with the specified `exception`
  const factory Event.failure(Object exception) = FailureEvent._;

  /// Creates a new success event with the specified `value`
  ///
  /// Contrary to `Response<T>`, this will NOT convert to `Event<T>.empty()`
  /// when `value` is null
  const factory Event.success(T value) = SuccessEvent._;

  @override
  String toString() => "{Event<${T}>}";

  /// This is a fancy `switch` that runs `failure`, `empty`, `waiting` or `success`, depending
  /// on which type of event this is.
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

  /// This is the same as `match`, but you can omit cases
  ///
  /// Any omitted case will fall to `otherwise`
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

/// Represents an empty event
@immutable
@sealed
class EmptyEvent<T> extends Event<T> implements IEmptyEvent {
  const EmptyEvent._() : super._();

  @override
  String toString() => "{EmptyEvent<${T}>}";
}

/// Represents a waiting event
@immutable
@sealed
class WaitingEvent<T> extends Event<T> implements IWaitingEvent {
  const WaitingEvent._() : super._();

  @override
  String toString() => "{WaitingEvent<${T}>}";
}

/// Represents a failure event
@immutable
@sealed
class FailureEvent<T> extends Event<T> implements IFailureEvent {
  const FailureEvent._(Object exception)
      : _exception = exception,
        super._();

  /// The exception information
  final Object _exception;

  @override
  Object get exception => _exception;

  @override
  String toString() => "{FailureEvent<${T}>:${_exception.runtimeType}:${_exception}}";
}

/// Represents a success event
@immutable
@sealed
class SuccessEvent<T> extends Event<T> implements ISuccessEvent {
  const SuccessEvent._(T value)
      : _value = value,
        super._();

  /// The success value
  final T _value;

  @override
  T get value => _value;

  @override
  String toString() => "{SuccessEvent<${T}>:${value}}";
}

/// Event dispatched when Eva is fully initialized
@immutable
class EvaReadyEvent {
  const EvaReadyEvent();
}

/// Event dispatched when an unhandled exception is thrown
@immutable
class UnexpectedExceptionEvent {
  const UnexpectedExceptionEvent(this.exception);

  final Object exception;
}
