import 'package:meta/meta.dart';

import '../events/event.dart';

enum ResponseType {
  failure,
  empty,
  success,
}

@immutable
class Response<T> {
  const Response.failure(Object exception)
      : type = ResponseType.failure,
        _exception = exception,
        _value = null;

  const Response.empty()
      : type = ResponseType.empty,
        _exception = null,
        _value = null;

  const Response.success(T? value)
      : type = value == null ? ResponseType.empty : ResponseType.success,
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

  final T? _value;

  TResult match<TResult>({
    required TResult Function(Object exception) failure,
    required TResult Function() empty,
    required TResult Function(dynamic value) success,
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

  TResult maybeMatch<TResult>({
    required TResult Function() otherwise,
    TResult Function(Object exception)? failure,
    TResult Function()? empty,
    TResult Function(dynamic value)? success,
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

  Event<TResult> mapToEvent<TResult>({TResult Function(T value)? success}) {
    return match(
      success: success == null ? (v) => Event<TResult>.success(v as TResult) : (value) => Event<TResult>.success(success(value as T)),
      empty: () => Event<TResult>.empty(),
      failure: (exception) => Event<TResult>.failure(exception),
    );
  }

  Response<TResult> map<TResult>({
    required Response<TResult> Function(T value) success,
    Response<TResult> Function(Object exception)? failure,
    Response<TResult> Function()? empty,
  }) {
    switch (type) {
      case ResponseType.failure:
        return failure == null ? Response<TResult>.failure(_exception!) : failure(_exception!);
      case ResponseType.empty:
        return empty == null ? Response<TResult>.empty() : empty();
      case ResponseType.success:
        return success(_value as T);
    }
  }

  Future<Response<TResult>> mapAsync<TResult>({
    required Future<Response<TResult>> Function(T value) success,
    Future<Response<TResult>> Function(Object exception)? failure,
    Future<Response<TResult>> Function()? empty,
  }) async {
    switch (type) {
      case ResponseType.failure:
        return failure == null ? Response<TResult>.failure(_exception!) : await failure(_exception!);
      case ResponseType.empty:
        return empty == null ? Response<TResult>.empty() : await empty();
      case ResponseType.success:
        return success(_value as T);
    }
  }

  @override
  String toString() {
    switch (type) {
      case ResponseType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case ResponseType.empty:
        return "{Empty}";
      case ResponseType.success:
        return "{Success<${_value.runtimeType}>:${_value}}";
    }
  }
}
