import 'package:meta/meta.dart';

enum _ResponseType {
  failure,
  empty,
  success,
}

@immutable
class Response {
  const Response.failure(Object exception)
      : _type = _ResponseType.failure,
        _exception = exception,
        _value = null;

  const Response.empty()
      : _type = _ResponseType.empty,
        _exception = null,
        _value = null;

  const Response.success([Object? value])
      : _type = value == null ? _ResponseType.empty : _ResponseType.success,
        _exception = null,
        _value = value;

  final _ResponseType _type;
  final Object? _exception;
  final Object? _value;

  T match<T>({
    required T Function(Object exception) failure,
    required T Function() empty,
    required T Function(dynamic value) success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure(_exception!);
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
    T Function()? empty,
    T Function(dynamic value)? success,
  }) {
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? otherwise() : failure(_exception!);
        case _ResponseType.empty:
          return empty == null ? otherwise() : empty();
        case _ResponseType.success:
          return success == null ? otherwise() : success(_value);
      }
    } catch (ex) {
      return failure == null ? otherwise() : failure(ex);
    }
  }

  @override
  String toString() {
    switch (_type) {
      case _ResponseType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case _ResponseType.empty:
        return "{Empty}";
      case _ResponseType.success:
        return "{SuccessOf<${_value.runtimeType}>:${_value}}";
    }
  }
}

@immutable
class ResponseOf<TSuccess> extends Response {
  const ResponseOf.failure(Object exception) : super.failure(exception);
  const ResponseOf.empty() : super.empty();
  const ResponseOf.success([TSuccess? value]) : super.success(value);

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
    try {
      switch (_type) {
        case _ResponseType.failure:
          return failure == null ? ResponseOf<TResult>.failure(_exception!) : failure(_exception!);
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
