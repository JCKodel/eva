import 'package:meta/meta.dart';

import '../validation/i_validation_error.dart';

enum _ResponseType {
  failure,
  validationErrors,
  empty,
  waiting,
  success,
}

@immutable
class Response<T> {
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

  const Response.waiting()
      : _type = _ResponseType.waiting,
        _exception = null,
        _value = null,
        _validationErrors = const [];

  const Response.success([T? value])
      : _type = value == null ? _ResponseType.empty : _ResponseType.success,
        _exception = null,
        _value = value,
        _validationErrors = const [];

  final _ResponseType _type;
  final Object? _exception;
  final T? _value;
  final Iterable<IValidationError> _validationErrors;

  TResponse match<TResponse>({
    required TResponse Function(Object exception) failure,
    required TResponse Function(Iterable<IValidationError> validationErrors) validationErrors,
    required TResponse Function() empty,
    required TResponse Function() waiting,
    required TResponse Function(T value) success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty();
        case _ResponseType.waiting:
          return waiting();
        case _ResponseType.success:
          return success(_value as T);
      }
    } catch (ex) {
      return failure(ex);
    }
  }

  TResponse maybeMatch<TResponse>({
    required TResponse Function() otherwise,
    TResponse Function(Object exception)? failure,
    TResponse Function(Iterable<IValidationError> validationErrors)? validationErrors,
    TResponse Function()? empty,
    TResponse Function()? waiting,
    TResponse Function(T value)? success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? otherwise() : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? otherwise() : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? otherwise() : empty();
        case _ResponseType.waiting:
          return waiting == null ? otherwise() : waiting();
        case _ResponseType.success:
          return success == null ? otherwise() : success(_value as T);
      }
    } catch (ex) {
      return failure == null ? otherwise() : failure(ex);
    }
  }

  Response<TResponse> map<TResponse>({
    Response<TResponse> Function(Object exception)? failure,
    Response<TResponse> Function(Iterable<IValidationError> validationErrors)? validationErrors,
    Response<TResponse> Function()? empty,
    Response<TResponse> Function()? waiting,
    Response<TResponse> Function(T value)? success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? Response<TResponse>.failure(_exception!) : failure(_exception!);
        case _ResponseType.validationErrors:
          return validationErrors == null ? Response<TResponse>.validationErrors(_validationErrors) : validationErrors(_validationErrors);
        case _ResponseType.empty:
          return empty == null ? Response<TResponse>.empty() : empty();
        case _ResponseType.waiting:
          return waiting == null ? Response<TResponse>.waiting() : waiting();
        case _ResponseType.success:
          return success == null ? Response<TResponse>.success(_value as TResponse) : success(_value as T);
      }
    } catch (ex) {
      return failure == null ? Response<TResponse>.failure(ex) : failure(ex);
    }
  }
}
