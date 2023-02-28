import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../events/event.dart';
import '../validation/i_validation_error.dart';

enum _ResponseType {
  failure,
  validationErrors,
  empty,
  success,
}

@immutable
class Response extends Equatable {
  const Response.failure(Object exception)
      : _type = _ResponseType.failure,
        _exception = exception,
        _value = null,
        _validationErrors = const [];

  const Response.validationErrors(Iterable<IValidationError> validationErrors)
      : _type = _ResponseType.validationErrors,
        _exception = null,
        _value = null,
        _validationErrors = validationErrors;

  const Response.empty()
      : _type = _ResponseType.empty,
        _exception = null,
        _value = null,
        _validationErrors = const [];

  const Response.success([Object? value])
      : _type = value == null ? _ResponseType.empty : _ResponseType.success,
        _exception = null,
        _value = value,
        _validationErrors = const [];

  final _ResponseType _type;
  final Object? _exception;
  final Object? _value;
  final Iterable<IValidationError> _validationErrors;

  T match<T>({
    required T Function(Object exception) failure,
    required T Function(Iterable<IValidationError> validationErrors) validationErrors,
    required T Function() empty,
    required T Function(dynamic value) success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty();
        case _ResponseType.success:
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
    T Function(dynamic value)? success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? otherwise() : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? otherwise() : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? otherwise() : empty();
        case _ResponseType.success:
          return success == null ? otherwise() : success(_value);
      }
    } catch (ex) {
      return failure == null ? otherwise() : failure(ex);
    }
  }

  Event toEvent({
    Event Function(dynamic value)? success,
    Event Function(Object exception)? failure,
    Event Function(Iterable<IValidationError> validationErrors)? validationErrors,
    Event Function()? empty,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? Event.failure(_exception!) : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? Event.validationErrors(_validationErrors) : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? const Event.empty() : empty();
        case _ResponseType.success:
          return success == null ? const EventOf.success(EmptyValue()) : success(_value);
      }
    } catch (ex) {
      return failure == null ? Event.failure(_exception!) : failure(_exception!);
    }
  }

  @override
  String toString() {
    switch (_type) {
      case _ResponseType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case _ResponseType.validationErrors:
        return "{ValidationError:${_validationErrors.map((v) => "<${v.runtimeType}:${v}>").join(", ")}}";
      case _ResponseType.empty:
        return "{Empty}";
      case _ResponseType.success:
        return "{SuccessOf<${_value.runtimeType}>:${_value}}";
    }
  }

  @override
  List<Object?> get props => [_type, _exception, _value, _validationErrors];
}

@immutable
class ResponseOf<TSuccess> extends Response {
  const ResponseOf.failure(Object exception) : super.failure(exception);
  const ResponseOf.validationErrors(Iterable<IValidationError> validationErrors) : super.validationErrors(validationErrors);
  const ResponseOf.empty() : super.empty();
  const ResponseOf.success([TSuccess? value]) : super.success(value);

  @override
  T match<T>({
    required T Function(Object exception) failure,
    required T Function(Iterable<IValidationError> validationErrors) validationErrors,
    required T Function() empty,
    required T Function(TSuccess value) success,
  }) {
    return super.match(
      failure: failure,
      validationErrors: validationErrors,
      empty: empty,
      success: (v) => success(v as TSuccess),
    );
  }

  @override
  T maybeMatch<T>({
    required T Function() otherwise,
    T Function(Object exception)? failure,
    T Function(Iterable<IValidationError> validationErrors)? validationErrors,
    T Function()? empty,
    T Function(TSuccess value)? success,
  }) {
    return super.maybeMatch(
      otherwise: otherwise,
      failure: failure,
      validationErrors: validationErrors,
      empty: empty,
      success: success == null ? null : (v) => success(v as TSuccess),
    );
  }

  EventOf<TResult> toEventTo<TResult extends Equatable>({
    required EventOf<TResult> Function(TSuccess value) success,
    EventOf<TResult> Function(Object exception)? failure,
    EventOf<TResult> Function(Iterable<IValidationError> validationErrors)? validationErrors,
    EventOf<TResult> Function()? empty,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? EventOf<TResult>.failure(_exception!) : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? EventOf<TResult>.validationErrors(_validationErrors) : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? EventOf<TResult>.empty() : empty();
        case _ResponseType.success:
          return success(_value as TSuccess);
      }
    } catch (ex) {
      return failure == null ? EventOf.failure(_exception!) : failure(_exception!);
    }
  }

  ResponseOf<TResult> map<TResult>({
    required ResponseOf<TResult> Function(TSuccess value) success,
    ResponseOf<TResult> Function(Object exception)? failure,
    ResponseOf<TResult> Function(Iterable<IValidationError> validationErrors)? validationErrors,
    ResponseOf<TResult> Function()? empty,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? ResponseOf<TResult>.failure(_exception!) : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? ResponseOf<TResult>.validationErrors(_validationErrors) : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? ResponseOf<TResult>.empty() : empty();
        case _ResponseType.success:
          return success(_value as TSuccess);
      }
    } catch (ex) {
      return failure == null ? ResponseOf<TResult>.failure(ex) : failure(ex);
    }
  }
}

@immutable
class EmptyValue extends Equatable {
  const EmptyValue();

  @override
  List<Object?> get props => [];
}
