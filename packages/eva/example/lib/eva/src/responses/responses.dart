import 'package:meta/meta.dart';

import '../events/event.dart';

enum ResponseType {
  failure,
  empty,
  success,
}

@immutable
class Response {
  const Response.failure(Object exception)
      : type = ResponseType.failure,
        _exception = exception,
        _value = null;

  const Response.empty()
      : type = ResponseType.empty,
        _exception = null,
        _value = null;

  const Response.success({Object? value, bool treatNullAsEmpty = false})
      : type = treatNullAsEmpty && value == null ? ResponseType.empty : ResponseType.success,
        _exception = null,
        _value = value;

  final ResponseType type;

  final Object? _exception;

  Object getException() {
    if (type != ResponseType.failure) {
      throw UnsupportedError("Cannot get exception from a response that is not a failure response");
    }

    return _exception!;
  }

  final Object? _value;

  T match<T>({
    required T Function(Object exception) failure,
    required T Function() empty,
    required T Function(dynamic value) success,
  }) {
    switch (type) {
      case ResponseType.failure:
        return failure(_exception!);
      case ResponseType.empty:
        return empty();
      case ResponseType.success:
        return success(_value);
    }
  }

  T maybeMatch<T>({
    required T Function() otherwise,
    T Function(Object exception)? failure,
    T Function()? empty,
    T Function(dynamic value)? success,
  }) {
    switch (type) {
      case ResponseType.failure:
        return failure == null ? otherwise() : failure(_exception!);
      case ResponseType.empty:
        return empty == null ? otherwise() : empty();
      case ResponseType.success:
        return success == null ? otherwise() : success(_value);
    }
  }

  Event<T> mapToEvent<T>({T Function(dynamic value)? success}) {
    return match(
      success: success == null ? (v) => Event<T>.success(v as T) : (value) => Event<T>.success(success(value)),
      empty: () => Event<T>.empty(),
      failure: (exception) => Event<T>.failure(exception),
    );
  }

  @override
  String toString() {
    switch (type) {
      case ResponseType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case ResponseType.empty:
        return "{Empty}";
      case ResponseType.success:
        return "{SuccessOf<${_value.runtimeType}>:${_value}}";
    }
  }

  ResponseOf<T> toResponseOf<T>({T Function()? success}) {
    return match(
      failure: ResponseOf<T>.failure,
      empty: ResponseOf<T>.empty,
      success: (_) => success == null ? ResponseOf<T>.empty() : ResponseOf<T>.success(success()),
    );
  }
}

@immutable
class ResponseOf<TSuccess> extends Response {
  const ResponseOf.failure(Object exception) : super.failure(exception);
  const ResponseOf.empty() : super.empty();
  const ResponseOf.success(TSuccess? value) : super.success(value: value, treatNullAsEmpty: true);

  TSuccess getValue() {
    if (type != ResponseType.success) {
      throw UnsupportedError("Cannot get value from a response that is not a success response");
    }

    return _value as TSuccess;
  }

  @override
  T match<T>({
    required T Function(Object exception) failure,
    required T Function() empty,
    required T Function(TSuccess value) success,
  }) {
    return super.match(
      failure: failure,
      empty: empty,
      success: (v) => success(v as TSuccess),
    );
  }

  @override
  T maybeMatch<T>({
    required T Function() otherwise,
    T Function(Object exception)? failure,
    T Function()? empty,
    T Function(TSuccess value)? success,
  }) {
    return super.maybeMatch(
      otherwise: otherwise,
      failure: failure,
      empty: empty,
      success: success == null ? null : (v) => success(v as TSuccess),
    );
  }

  ResponseOf<TResult> map<TResult>({
    required ResponseOf<TResult> Function(TSuccess value) success,
    ResponseOf<TResult> Function(Object exception)? failure,
    ResponseOf<TResult> Function()? empty,
  }) {
    switch (type) {
      case ResponseType.failure:
        return failure == null ? ResponseOf<TResult>.failure(_exception!) : failure(_exception!);
      case ResponseType.empty:
        return empty == null ? ResponseOf<TResult>.empty() : empty();
      case ResponseType.success:
        return success(_value as TSuccess);
    }
  }

  @override
  Event<T> mapToEvent<T>({T Function(TSuccess value)? success}) {
    return match(
      success: success == null ? (v) => Event<T>.success(v as T) : (value) => Event<T>.success(success(value)),
      empty: () => Event<T>.empty(),
      failure: (exception) => Event<T>.failure(exception),
    );
  }
}
