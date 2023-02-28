import 'package:meta/meta.dart';

import '../entities/i_equatable.dart';
import '../validation/i_validation_error.dart';

enum _EventType {
  failure,
  validationErrors,
  empty,
  waiting,
  success,
}

@immutable
class Event implements IEquatable {
  const Event.failure(Object exception)
      : _type = _EventType.failure,
        _exception = exception,
        _value = null,
        _validationErrors = const [];

  const Event.validationErrors(Iterable<IValidationError> validationErrors)
      : _type = _EventType.validationErrors,
        _exception = null,
        _value = null,
        _validationErrors = validationErrors;

  const Event.empty()
      : _type = _EventType.empty,
        _exception = null,
        _value = null,
        _validationErrors = const [];

  const Event.waiting()
      : _type = _EventType.waiting,
        _exception = null,
        _value = null,
        _validationErrors = const [];

  const Event.success([Object? value])
      : _type = value == null ? _EventType.empty : _EventType.success,
        _exception = null,
        _value = value,
        _validationErrors = const [];

  final _EventType _type;
  final Object? _exception;
  final Object? _value;
  final Iterable<IValidationError> _validationErrors;

  T match<T>({
    required T Function(Object exception) failure,
    required T Function(Iterable<IValidationError> validationErrors) validationErrors,
    required T Function() empty,
    required T Function() waiting,
    required T Function(dynamic value) success,
  }) {
    try {
      switch (_type) {
        case _EventType.failure:
          return failure(_exception!);
        case _EventType.validationErrors:
          return validationErrors(_validationErrors);
        case _EventType.empty:
          return empty();
        case _EventType.waiting:
          return waiting();
        case _EventType.success:
          return success(_value);
      }
    } catch (ex) {
      return failure(ex);
    }
  }

  T maybeMatch<T>({
    required T Function() otherwise,
    T Function(Object exception)? failure,
    T Function(Iterable<IValidationError> validationErrors)? validationErrors,
    T Function()? empty,
    T Function()? waiting,
    T Function(dynamic value)? success,
  }) {
    try {
      switch (_type) {
        case _EventType.failure:
          return failure == null ? otherwise() : failure(_exception!);
        case _EventType.validationErrors:
          return validationErrors == null ? otherwise() : validationErrors(_validationErrors);
        case _EventType.empty:
          return empty == null ? otherwise() : empty();
        case _EventType.waiting:
          return waiting == null ? otherwise() : waiting();
        case _EventType.success:
          return success == null ? otherwise() : success(_value);
      }
    } catch (ex) {
      return failure == null ? otherwise() : failure(ex);
    }
  }

  @override
  String toString() {
    switch (_type) {
      case _EventType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case _EventType.validationErrors:
        return "{ValidationError:${_validationErrors.map((v) => "<${v.runtimeType}:${v}>").join(", ")}}";
      case _EventType.empty:
        return "{Empty}";
      case _EventType.waiting:
        return "{Waiting}";
      case _EventType.success:
        return "{SuccessOf<${_value.runtimeType}>:${_value}}";
    }
  }

  @override
  bool equals(Object other) {
    return other == this;
  }

  @override
  bool operator ==(Object other) {
    if (other is Event == false) {
      return false;
    }

    if (identical(this, other)) {
      return true;
    }

    // ignore: test_types_in_equals
    final o = other as Event;

    if (o._type != _type) {
      return false;
    }

    switch (_type) {
      case _EventType.failure:
        return false;
      case _EventType.validationErrors:
        if (o._validationErrors.length != _validationErrors.length || o.runtimeType != runtimeType) {
          return false;
        }

        final ol = o._validationErrors.toList();
        final l = _validationErrors.toList();

        for (var ct = 0; ct < l.length; ct++) {
          if (ol[ct] != l[ct]) {
            return false;
          }
        }

        return true;
      case _EventType.empty:
        return true;
      case _EventType.waiting:
        return true;
      case _EventType.success:
        if (_value is IEquatable) {
          return o.runtimeType == runtimeType && (_value as IEquatable).equals(o._value!);
        }

        return o.runtimeType == runtimeType && o._value == _value;
    }
  }

  @override
  int get hashCode {
    switch (_type) {
      case _EventType.failure:
        return _exception.hashCode;
      case _EventType.validationErrors:
        return Object.hashAll(_validationErrors);
      case _EventType.empty:
        return _EventType.empty.hashCode;
      case _EventType.waiting:
        return _EventType.waiting.hashCode;
      case _EventType.success:
        return _value.hashCode;
    }
  }
}

@immutable
class EventOf<TSuccess> extends Event {
  const EventOf.failure(Object exception) : super.failure(exception);
  const EventOf.validationErrors(Iterable<IValidationError> validationErrors) : super.validationErrors(validationErrors);
  const EventOf.empty() : super.empty();
  const EventOf.waiting() : super.waiting();
  const EventOf.success([TSuccess? value]) : super.success(value);

  @override
  T match<T>({
    required T Function(Object exception) failure,
    required T Function(Iterable<IValidationError> validationErrors) validationErrors,
    required T Function() empty,
    required T Function() waiting,
    required T Function(TSuccess value) success,
  }) {
    return super.match(
      failure: failure,
      validationErrors: validationErrors,
      empty: empty,
      waiting: waiting,
      success: (v) => success(v as TSuccess),
    );
  }

  @override
  T maybeMatch<T>({
    required T Function() otherwise,
    T Function(Object exception)? failure,
    T Function(Iterable<IValidationError> validationErrors)? validationErrors,
    T Function()? empty,
    T Function()? waiting,
    T Function(TSuccess value)? success,
  }) {
    return super.maybeMatch(
      otherwise: otherwise,
      failure: failure,
      validationErrors: validationErrors,
      empty: empty,
      waiting: waiting,
      success: success == null ? null : (v) => success(v as TSuccess),
    );
  }

  EventOf<TResult> map<TResult>({
    required EventOf<TResult> Function(TSuccess value) success,
    EventOf<TResult> Function(Object exception)? failure,
    EventOf<TResult> Function(Iterable<IValidationError> validationErrors)? validationErrors,
    EventOf<TResult> Function()? empty,
    EventOf<TResult> Function()? waiting,
  }) {
    try {
      switch (_type) {
        case _EventType.failure:
          return failure == null ? EventOf<TResult>.failure(_exception!) : failure(_exception!);
        case _EventType.validationErrors:
          return validationErrors == null ? EventOf<TResult>.validationErrors(_validationErrors) : validationErrors(_validationErrors);
        case _EventType.empty:
          return empty == null ? EventOf<TResult>.empty() : empty();
        case _EventType.waiting:
          return waiting == null ? EventOf<TResult>.waiting() : waiting();
        case _EventType.success:
          return success(_value as TSuccess);
      }
    } catch (ex) {
      return failure == null ? EventOf<TResult>.failure(ex) : failure(ex);
    }
  }
}
